class NeedBigIntForSatoshi < ActiveRecord::Migration
  def up
    change_column :btc_transactions, :satoshi, :bigint
  end
  
  def down
    change_column :btc_transactions, :satoshi, :integer    
  end
end
