class AddOutboundAddressToUsers < ActiveRecord::Migration
  def change
    add_column :users, :outbound_bitcoin_address, :string
    add_column :users, :msg_email, :string
  end
end
