namespace :db do
  desc "Process queued withdrawals"
  task :process_wd_queue => :environment do
    # How much do we have total
    balance = BITCOIN_GATEWAY.get_wallet_balance(false).as_satoshi
    
    # Pay smallest ones first - they are negative, so need descending order
    BtcTransaction.queued.order('satoshi DESC').each do |transaction|
      break if balance < transaction.satoshi.abs 
      
      transaction_id = BITCOIN_GATEWAY.withdraw(transaction.address, transaction.satoshi.abs)
      if !transaction_id.nil?
        transaction.transaction_id = transaction_id
        transaction.pending = false
        transaction.save!
        
        balance -= transaction.satoshi.abs
      end   
    end
  end
end
