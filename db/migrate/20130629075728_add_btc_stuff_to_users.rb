class AddBtcStuffToUsers < ActiveRecord::Migration
  def change
    add_column :users, :total_bitcoin_in, :float
    add_column :users, :total_bitcoin_out, :float
    add_column :users, :total_address_balance, :float
  end
end
