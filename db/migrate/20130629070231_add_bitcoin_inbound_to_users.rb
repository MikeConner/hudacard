class AddBitcoinInboundToUsers < ActiveRecord::Migration
  def change
    add_column :users, :bitcoin_inbound, :string
  end
end
