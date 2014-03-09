class AddStartingTimeToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :startTime, :datetime
    add_column :tasks, :endTime, :datetime
    add_column :tasks, :done, :boolean
  end
end
