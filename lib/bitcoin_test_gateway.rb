require 'bitcoin'

class BitcoinTestGateway < BitcoinGateway  
  class << self; attr_accessor :total_received end
  @total_received = 0
  
  def test?
    true
  end
  
  def create_inbound_address(email)
    SecureRandom.hex(12)
  end
  
  # Need to ensure this is monotonically increasing
  def get_total_received(address, confirmations = 0)    
    BitcoinTestGateway::total_received += Bitcoin.new(:btc => (Random.rand * 5).round(3)).as_satoshi
    
    Bitcoin.new(:satoshi => BitcoinTestGateway::total_received.round)
  end
  
  def withdraw(address, amount)
    # If you don't reset this, you'll get an inconsistency when you try a balance update
    BitcoinTestGateway::total_received = 0

    SecureRandom.base64(16)
  end  
  
  def get_wallet_balance(should_fail = false)
    should_fail ? nil : Bitcoin.new(:satoshi => Bitcoin.new(:btc => (Random.rand(100) + 1)).as_satoshi)
  end
end