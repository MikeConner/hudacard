class AddRandomToUsers < ActiveRecord::Migration
  def change
    add_column :users, :random_token, :string
  end
end
