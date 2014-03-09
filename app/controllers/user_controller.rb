class UserController < ApplicationController
  before_filter :authenticate_user!
  before_filter :self_or_admin!, only: [:set_current_task, :complete_current_task, :tasks, :set_tasks]
  before_filter :authenticate_admin!, only: [:approve_account, :promote, :destroy]

  def self_or_admin!
    params[:id] == current_user.id || authenticate_admin!
  end

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
    render json: {project: temp_task.project.name, time: temp_task.startTime.to_formatted_s(:short) }
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

  def tasks
    render json: Task.where(user: User.find(params[:id])).map { |t| { id: t.id, title: t.name, start: t.startTime, :end => t.startTime + t.hours.hours + t.minutes.minutes }}
  end

  def set_tasks
    data.each do |task|
      temp_task = Task.where(id: task.id).first_or_create
      seconds = task.end - task.start
      hours = seconds / 3600
      minutes = seconds / 60
      temp_task.update_attributes(name: task.title, startTime: task.start, hours: hours.floor, minutes: minutes.floor)
      if !temp_task.valid?
        temp_project = Project.where(name: "UNKNOWN").first_or_create
        temp_task.update_attribute(:project_id, temp_project.id)
        temp_task.save
      end
    end
  end

  def approve_account
    User.find(params[:id]).update_attribute(:approved, true)
    redirect_to :users, notice: user.email + ' was approved'
  end

  def promote
    user = User.find(params[:id])
    user.update_attribute(:role, 'admin')
    redirect_to :users, notice: user.email + ' was promoted'
  end

  def destroy
    User.find(params[:id]).destroy
    redirect_to :users, notice: 'Destroyed'
  end
end
