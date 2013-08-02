class RemovePayoutRatioFromGames < ActiveRecord::Migration
  def up
    remove_column :games, :payout_ratio
  end

  def down
    add_column :games, :payout_ratio, :float
  end
end
