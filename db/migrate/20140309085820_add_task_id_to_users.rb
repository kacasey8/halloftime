class AddTaskIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :currentTask_id, :integer
  end
end
