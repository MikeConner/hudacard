require 'singleton'

class BitcoinGateway
  include Singleton
  
  def create_inbound_address(email)
    webResponse = HTTParty.get("https://blockchain.info/merchant/#{MERCHANT_KEY}/new_address?password=#{MERCHANT_PASSWORD}&label=#{email}")
    if webResponse.has_key?('address')
      webResponse['address']
    else
      puts webResponse.inspect
      
      # This can happen if we're out of addresses for this wallet
      puts 'Unable to create BTC address'
      # puts returns nil
    end
  end
  
  def get_total_received(address, confirmations = 0)
    webResponse = HTTParty.get("https://blockchain.info/q/getreceivedbyaddress/#{address}?confirmations=#{confirmations}")

    webResponse.blank? ? nil : webResponse.to_i
  end
  
  def withdraw(address, amount)
    webResponse = HTTParty.get("https://blockchain.info/merchant/#{MERCHANT_KEY}/payment?password=#{MERCHANT_PASSWORD}&to=#{address}&amount=#{amount}&shared=false")
    if webResponse.has_key?('tx_hash')
      webResponse['tx_hash']
    else
      puts webResponse.inspect
      # puts returns nil
    end    
  end
end