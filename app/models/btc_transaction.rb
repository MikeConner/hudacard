# == Schema Information
#
# Table name: btc_transactions
#
#  id               :integer          not null, primary key
#  satoshi          :integer
#  address          :string(255)
#  transaction_id   :string(255)
#  user_id          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  pending          :boolean          default(FALSE), not null
#  transaction_type :string(255)      default("Game"), not null
#

# CHARTER
#   Encapsulate a Bitcoin transaction
#
# USAGE
#    Inbound/Outbound based on positive/negative
#
# NOTES AND WARNINGS
#
class BtcTransaction < ActiveRecord::Base
  GAME_TRANSACTION = 'Game'
  FUNDING_TRANSACTION = 'Funding'
  WITHDRAWAL_TRANSACTION = 'Withdrawal'
  
  TRANSACTION_TYPES = [GAME_TRANSACTION, FUNDING_TRANSACTION, WITHDRAWAL_TRANSACTION]
  
  MINER_FEE = Bitcoin.new(:btc => 0.0001)
  
  # Satoshi reflects the net deposit (so, negative = withdrawal)
  #   if a withdrawal, address has the destination; otherwise it's deposited into the inbound address associated with the user
  attr_accessible :satoshi, :address, :transaction_id, :transaction_type,
                  :user_id

  belongs_to :user
  
  validates :satoshi, :presence => true,
                      :numericality => { :only_integer => true },
                      :exclusion => { :in => [0.0] }
  validates :address, :presence => { :if => :outbound? }
  validates :transaction_id, :presence => { :if => :outbound? }
  validates :pending, :inclusion => { :in => [true, false] }
  validates :transaction_type, :inclusion => { :in => TRANSACTION_TYPES } 
  
  scope :inbound, where('satoshi > 0')
  scope :outbound, where('satoshi < 0')
  scope :external, where("(transaction_type = ?) or (transaction_type = ?)", FUNDING_TRANSACTION, WITHDRAWAL_TRANSACTION)
  
  scope :queued, where("pending = #{ActiveRecord::Base.connection.quoted_true}")
  scope :settled, where("pending = #{ActiveRecord::Base.connection.quoted_false}")
  
  def outbound?
    self.satoshi < 0
  end
end
