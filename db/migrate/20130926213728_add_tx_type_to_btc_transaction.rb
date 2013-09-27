class AddTxTypeToBtcTransaction < ActiveRecord::Migration
  def change
    add_column :btc_transactions, :transaction_type, :string, :null => false, :default => BtcTransaction::GAME_TRANSACTION
  end
end
