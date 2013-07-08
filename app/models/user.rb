class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :balance, :bitcoin_inbound

  attr_accessible :total_bitcoin_in, :total_bitcoin_out, :total_address_balance
  attr_accessible :random_token

  # attr_accessible :title, :body
  has_many :games
  has_many :btc_transactions

  def get_btc_address
    if self.bitcoin_inbound.nil?
      webResponse = HTTParty.get('https://blockchain.info/merchant/61e9e217-d259-4ed2-9939-09ce5f071fe4/new_address?password=$tamP3d3$!@&label='+self.email)
      self.bitcoin_inbound = webResponse['address']
      self.total_bitcoin_in = 0
      self.total_bitcoin_out = 0
      self.balance = 0
      self.save!
    end
  end

  def get_btc_total_recieved(conf=0)    
    if !self.bitcoin_inbound.nil?
      conf = 0

      #first check to see how many btc have arrived

      webResponse = HTTParty.get('https://blockchain.info/q/getreceivedbyaddress/' + self.bitcoin_inbound + '?confirmations=' + conf.to_s )
      total_bitcoin_in = webResponse.to_i

      #second, add in additional bitcoin in if greater than what has come in previously

      if self.total_bitcoin_in < total_bitcoin_in
        self.balance = self.balance + total_bitcoin_in - self.total_bitcoin_in
        txn_log = BTCTransaction.new
        txn_log.save_incoming self.id, total_bitcoin_in - self.total_bitcoin_in, self.bitcoin_inbound
        self.total_bitcoin_in = total_bitcoin_in
        self.save!
      end
    end
    self.total_bitcoin_in
  end

  def withdraw(outbound)
    #ensure balance has enough to send out
    if self.balance > 0.0005*100000000 
      #make sure inbounds are fully confirmed
      zeroconf = get_btc_total_recieved(0)
      oneconf = get_btc_total_recieved(1)
      twoconf = get_btc_total_recieved(2)
      #threeconf = get_btc_total_recieved(3)
      if zeroconf == oneconf and oneconf == twoconf 
        #take out fee before sending withdraw
        webResponse = HTTParty.get('https://blockchain.info/merchant/61e9e217-d259-4ed2-9939-09ce5f071fe4/payment?password=$tamP3d3$!@&to=' + outbound + '&amount=' + (self.balance - 50000).floor.to_s + '&shared=false' )
        # make sure success ! 
        # update outbound
        txn_log = BTCTransaction.new
        txn_log.save_outgoing self.id, (self.balance - 50000).floor.to_s, outbound

        self.total_bitcoin_out = self.total_bitcoin_out + self.balance 
        self.balance = 0;
        self.save!
      else
        "Waiting for 2 Confirmation on Inbounds"
      end
    else
      "Balance Too Low "
    end 
  end
  # catch condition -> 0 (success)
  #catch condition: {"error"=>"Insufficient Funds Available: 9950000 Needed: 9959020"}  - waLLET!!!
  #{"message"=>"Sent 0.099 BTC to 1H7j8aZ9R2oGs1mxsiGMt446QqgYkZDaiz", "tx_hash"=>"fd081a0ceea637672a5bca80a79a9150f307282811c46e2e233432bf4aedeb1d"}

end
