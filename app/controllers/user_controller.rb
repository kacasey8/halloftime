class UserController < ApplicationController
  before_filter :authenticate_user!
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @hours = @user.tasks.sum(:hours)
    @minutes = @user.tasks.sum(:minutes)
    @hours += @minutes / 60
    @minutes = @minutes % 60
  end

  def set_current_task
    temp_task = Task.create(name: params[:name], user: current_user, project_id: params[:project_id], hours: 0, minutes: 0, startTime: Time.now)
    current_user.update_attribute(:currentTask_id, temp_task.id)
    render json: temp_task.project
  end

  def complete_current_task
    task = current_user.currentTask
    if task
      seconds = Time.now - task.startTime
      hours = seconds / 3600
      minutes = seconds / 60
      task.update_attributes(done: true, hours: hours.floor, minutes: minutes.floor)
      current_user.update_attribute(:currentTask_id, nil)
      render json: task
    end
  end

  def approve_account
    User.find(params[:id]).update_attribute(:approved, true)
    redirect_to :users
  end
end
