class AddSecurityCodeToGames < ActiveRecord::Migration
  def change
    add_column :games, :security_code, :string
  end
end
