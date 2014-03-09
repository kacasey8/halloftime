class Task < ActiveRecord::Base
  belongs_to :user
  belongs_to :project

  validates_presence_of :name, :user_id, :project_id, :hours, :minutes
end
