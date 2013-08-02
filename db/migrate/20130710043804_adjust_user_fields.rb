class AdjustUserFields < ActiveRecord::Migration
  def up
    remove_column :users, :total_address_balance
    remove_column :users, :bitcoin_inbound
    add_column :users, :inbound_bitcoin_address, :string
    remove_column :users, :total_bitcoin_in
    remove_column :users, :total_bitcoin_out
    remove_column :users, :balance
  end

  def down
    add_column :users, :total_address_balance, :float
    add_column :users, :bitcoin_inbound, :string
    remove_column :users, :inbound_bitcoin_address
    add_column :users, :total_bitcoin_in, :float
    add_column :users, :total_bitcoin_out, :float
    add_column :users, :balance, :float
  end
end
