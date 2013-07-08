class CreateBtcTransactions < ActiveRecord::Migration
  def change
    create_table :btc_transactions do |t|
      t.datetime :txn_date
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
