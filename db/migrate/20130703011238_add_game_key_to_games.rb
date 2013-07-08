class AddGameKeyToGames < ActiveRecord::Migration
  def change
    add_column :games, :game_key, :string
  end
end
