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
    BitcoinTestGateway::total_received += (Random.rand * 5).round(3) 
    
    BitcoinTestGateway::total_received
  end
  
  def withdraw(address, amount)
    SecureRandom.base64(16)
    # If you don't reset this, you'll get an inconsistency when you try a balance update
    BitcoinTestGateway::total_received = 0
  end  
end