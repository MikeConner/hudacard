class AdjustTransactionFields < ActiveRecord::Migration
  def up
    drop_table :btc_transactions
    create_table :btc_transactions do |t|
      t.integer :satoshi
      t.string :address
      t.string :transaction_id
      t.integer :user_id

      t.timestamps
    end
  end

  def down
    drop_table :btc_transactions
    create_table :btc_transactions do |t|
      t.integer :satoshi_in
      t.integer :satoshi_out
      t.string :from_address
      t.string :to_address
      t.integer :user_id
      t.string :label

      t.timestamps
    end
  end
end
