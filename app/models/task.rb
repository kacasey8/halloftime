# == Schema Information
#
# Table name: tasks
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  user_id    :integer
#  project_id :integer
#  hours      :integer
#  minutes    :integer
#  created_at :datetime
#  updated_at :datetime
#  startTime  :datetime
#  endTime    :datetime
#  done       :boolean
#

class Task < ActiveRecord::Base
  belongs_to :user
  belongs_to :project

  validates_presence_of :user_id, :project_id, :hours, :minutes
end
