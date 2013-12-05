class BtcTransactionsController < ApplicationController
  before_filter :ensure_admin

  def index
    @queued = BtcTransaction.queued.order('user_id')
    if !@queued.empty?
      @balance = BITCOIN_GATEWAY.get_wallet_balance(false).as_satoshi
    end
  end  
  
  def update
    @transaction = BtcTransaction.find(params[:id])
    # pay it
    transaction_id = BITCOIN_GATEWAY.withdraw(@transaction.address, @transaction.satoshi.abs)
    if !transaction_id.nil?
      @transaction.transaction_id = transaction_id
      @transaction.pending = false
      @transaction.save!
      
      redirect_to btc_transactions_path(:key => params[:key])
    end
  end
  
private
  def ensure_admin
    if current_user.nil? or !current_user.admin?
      redirect_to root_path, :alert => I18n.t('admins_only')
    end
  end
end