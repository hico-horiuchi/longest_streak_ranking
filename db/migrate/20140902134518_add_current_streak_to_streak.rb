class AddCurrentStreakToStreak < ActiveRecord::Migration
  def change
    remove_column :streaks, :longest_streak
    add_column :streaks, :longest_streak, :integer
    add_column :streaks, :current_streak, :integer
  end
end
