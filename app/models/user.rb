# == Schema Information
#
# Table name: users
#
#  id                      :integer          not null, primary key
#  email                   :string(255)      default(""), not null
#  encrypted_password      :string(255)      default(""), not null
#  reset_password_token    :string(255)
#  reset_password_sent_at  :datetime
#  remember_created_at     :datetime
#  sign_in_count           :integer          default(0)
#  current_sign_in_at      :datetime
#  last_sign_in_at         :datetime
#  current_sign_in_ip      :string(255)
#  last_sign_in_ip         :string(255)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  inbound_bitcoin_address :string(255)
#

class User < ActiveRecord::Base
  extend FriendlyId
  friendly_id :random_token
  
  include ApplicationHelper
  
  # Store random token in the email, appending the suffix to make it valid
  # This token will also appear in all this user's games
  EMAIL_SUFFIX = '@me.com'
  SATOSHI = 100000000
  
  # Could say :on => :create, but not necessary because it's already got a latch to only do it once
  before_validation :ensure_btc_address
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  # New address created for this user
  attr_accessible :inbound_bitcoin_address
  # This is the unique web URL that identifies a user -- don't allow mass assignment
  attr_accessor :random_token
  
  has_many :games, :dependent => :restrict
  has_many :btc_transactions, :dependent => :restrict

  validates :email, :presence => true,
                    :uniqueness => { case_sensitive: false },
                    :format => { with: EMAIL_REGEX }
  validates_presence_of :inbound_bitcoin_address
  
  def has_pending_withdrawals?
    self.btc_transactions.queued.outbound.count > 0
  end
  
  # Minimum - maximum allowed to bet
  # Return a hash of min/max
  def bet_range
    satoshi_balance = self.balance
    max_bet = satoshi_balance / 300000
    
    # in millis (return MIN/MIN if max is 0; this allows betting with zero balance)
    {:min => Game::MINIMUM_BET, :max => max_bet < Game::MINIMUM_BET ? Game::MINIMUM_BET : max_bet}
  end
  
  # Compute each time, so that it never gets out of sync
  # Add balance field back if this becomes a performance issue
  def balance
    result = 0
    self.btc_transactions.settled.each do |transaction|
      result += transaction.satoshi
    end
    
    # Sanity check - has to be >= 0
    if result < 0
      raise "Invalid balance (#{result})"
    end
    
    result
  end
  
  def total_bitcoin_in
    result = 0
    self.btc_transactions.inbound.each do |transaction|
      result += transaction.satoshi
    end
    
    result
  end

  def get_btc_total_received(required_confirmations = 0)    
    if self.inbound_bitcoin_address.nil?
      # This means uninitialized, so it better be 0
      if 0 != self.total_bitcoin_in
        raise "#{self.total_bitcoin_in} bitcoin found; 0 expected"
      end
    else
      # first check to see how many btc have arrived
      total_received = BITCOIN_GATEWAY.get_total_received(self.inbound_bitcoin_address, required_confirmations)
      
      if total_received.nil?
        raise 'Unable to get received BTC'
      else
        # second, add in additional bitcoin if greater than what has come in previously
        difference = (total_received * SATOSHI).round - self.total_bitcoin_in
        if difference > 0
          self.btc_transactions.create!(:satoshi => difference)
        elsif difference < 0
          raise "Total received discrepancy on #{self.inbound_bitcoin_address} (#{difference})"
        end
      end
    end
    
    self.total_bitcoin_in
  end

  # add default argument that can be set in test mode to make it queue withdrawals
  def withdraw(outbound_address, should_fail = false)
    if balance < BtcTransaction::MINER_FEE
      I18n.t('low_balance')
    else
      # Unfortunately the get_btc_total_received creates transactions in the test system, and the numbers will never match
      #   So we need special code
      if BITCOIN_GATEWAY.test?
        balance = self.balance
        amount = balance - BtcTransaction::MINER_FEE
        
        escrow_balance = BITCOIN_GATEWAY.get_wallet_balance(should_fail)
        
        if escrow_balance.nil? or (escrow_balance < balance)
          # Need to queue
          tx = self.btc_transactions.create!(:satoshi => -balance, :address => outbound_address, :transaction_id => 'pending')
          tx.pending = true
          tx.save!
          "Withdrawal queued. Amount: #{balance}"   
        else
          transaction_id = BITCOIN_GATEWAY.withdraw(outbound_address, amount)
          if transaction_id.nil?
            raise "Withdrawal from #{outbound_address} failed"
          else
            self.btc_transactions.create!(:satoshi => -balance, :address => outbound_address, :transaction_id => transaction_id)
          end    
          
          "Withdrawal successful. Amount: #{balance}"   
        end 
      else
        zeroconf = get_btc_total_received(0)
        oneconf = get_btc_total_received(1)
        twoconf = get_btc_total_received(2)
        if (zeroconf == oneconf) and (oneconf == twoconf) 
          balance = self.balance
          amount = balance - BtcTransaction::MINER_FEE
          
          escrow_balance = BITCOIN_GATEWAY.get_wallet_balance
          
          if escrow_balance.nil? or (escrow_balance < balance)
            # Need to queue
            tx = self.btc_transactions.create!(:satoshi => -balance, :address => outbound_address, :transaction_id => 'pending')
            tx.pending = true
            tx.save!
            "Withdrawal queued. Amount: #{balance}"   
          else
            transaction_id = BITCOIN_GATEWAY.withdraw(outbound_address, amount)
            if transaction_id.nil?
              raise "Withdrawal from #{outbound_address} failed"
            else
              self.btc_transactions.create!(:satoshi => -balance, :address => outbound_address, :transaction_id => transaction_id)
            end
            
            "Withdrawal successful. Amount: #{balance}" 
          end  
        else
          I18n.t('awaiting_confirmation')
        end
      end
    end 
  end
  
private
  # recover from email
  def random_token
    if self.email =~ /(.*?)@/
      $1
    else
      self.id
    end
  end
  
  # Make sure the user has a bitcoin_inbound address defined
  def ensure_btc_address
    if self.inbound_bitcoin_address.nil?
      self.inbound_bitcoin_address = BITCOIN_GATEWAY.create_inbound_address(self.email)
    end
    
    raise 'Could not create inbound bitcoin address' if self.inbound_bitcoin_address.nil?
  end
end
