class MoveRandomToken < ActiveRecord::Migration
  def up
    remove_column :users, :random_token
    remove_column :games, :session_id
    add_column :games, :random_token, :string, :limit => 48
    change_column :games, :color, :string, :limit => 8
    change_column :games, :security_code, :string, :limit => 128
    change_column :games, :game_key, :string, :limit => 32
    change_column :games, :bet, :integer, :null => false, :default => 1
  end

  def down
    add_column :users, :random_token, :string
    add_column :games, :session_id, :string
    remove_column :games, :random_token
  end
end
