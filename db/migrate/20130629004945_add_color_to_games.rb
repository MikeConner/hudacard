class AddColorToGames < ActiveRecord::Migration
  def change
    add_column :games, :color, :string
  end
end
