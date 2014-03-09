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
    require 'debugger'
    debugger
    p "hi"
  end
end
