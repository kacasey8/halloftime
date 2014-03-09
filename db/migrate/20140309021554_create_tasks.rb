class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.integer :user_id
      t.integer :project_id
      t.integer :hours
      t.integer :minutes

      t.timestamps
    end
  end
end
