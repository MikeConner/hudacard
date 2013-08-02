class RemoveCardModel < ActiveRecord::Migration
  def up
    drop_table :cards
    remove_column :games, :card1
    remove_column :games, :card2
    remove_column :games, :card3
    remove_column :games, :card4
    remove_column :games, :card5
    add_column :games, :cards, :string
  end

  def down
    create_table :cards do |t|
      t.string :suit
      t.string :value

      t.timestamps
    end
    
    add_column :games, :card1, :string
    add_column :games, :card2, :string
    add_column :games, :card3, :string
    add_column :games, :card4, :string
    add_column :games, :card5, :string
    remove_column :games, :cards
  end
end
