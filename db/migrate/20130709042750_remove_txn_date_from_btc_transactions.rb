class RemoveTxnDateFromBtcTransactions < ActiveRecord::Migration
  def up
    remove_column :btc_transactions, :txn_date
    change_column :btc_transactions, :satoshi_in, :integer, :null => false, :default => 0
    change_column :btc_transactions, :satoshi_out, :integer, :null => false, :default => 0
    change_column :btc_transactions, :to_address, :string, :null => false
  end

  def down
    add_column :btc_transactions, :txn_date, :datetime
    change_column :btc_transactions, :satoshi_in, :integer, :null => true
    change_column :btc_transactions, :satoshi_out, :integer, :null => true
    change_column :btc_transactions, :to_address, :string, :null => true
  end
end
