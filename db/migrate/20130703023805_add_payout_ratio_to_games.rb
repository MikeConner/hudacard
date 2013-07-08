class AddPayoutRatioToGames < ActiveRecord::Migration
  def change
    add_column :games, :payout_ratio, :float
  end
end
