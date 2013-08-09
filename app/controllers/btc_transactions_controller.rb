class BtcTransactionsController < ApplicationController
  def index
    if ADMIN_KEY == params['key']
      @queued = BtcTransaction.queued.order('user_id')
      if !@queued.empty?
        @balance = BITCOIN_GATEWAY.get_wallet_balance(false).as_satoshi
      end
    else
      @errors = 'Invalid security key'
      render 'games/error'
    end
  end  
  
  def update
    if ADMIN_KEY == params['key']
      @transaction = BtcTransaction.find(params[:id])
      # pay it
      transaction_id = BITCOIN_GATEWAY.withdraw(@transaction.address, @transaction.satoshi.abs)
      if !transaction_id.nil?
        @transaction.transaction_id = transaction_id
        @transaction.pending = false
        @transaction.save!
        
        redirect_to btc_transactions_path(:key => params[:key])
      end
    else
      @errors = 'Invalid security key'
      render 'games/error'
    end
  end
end