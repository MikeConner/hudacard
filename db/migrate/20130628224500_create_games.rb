class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.float :bet
      t.string :card1
      t.string :card2
      t.string :card3
      t.string :card4
      t.string :card5
      t.integer :user_id
      t.float :payout

      t.timestamps
    end
  end
end
