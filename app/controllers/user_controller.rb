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
    temp_task = Task.create(name: params[:name], user: current_user, project_id: params[:project_id], hours: 0, minutes: 0)
    current_user.update_attribute(:currentTask_id, temp_task.id)
    debugger
    render json: temp_task
  end
end
