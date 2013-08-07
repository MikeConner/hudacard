class AddPendingFlagToBtcTransactions < ActiveRecord::Migration
  def change
    add_column :btc_transactions, :pending, :boolean, :null => false, :default => false
  end
end
