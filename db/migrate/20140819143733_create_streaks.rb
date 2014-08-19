class CreateStreaks < ActiveRecord::Migration
  def change
    create_table :streaks do |t|
      t.string :username, null: false
      t.integer :longest_streak, null: false

      t.timestamps
    end
  end
end
