class TasksController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_task, only: [:edit, :update, :destroy]

  respond_to :html, :js

  def index
    @tasks = current_user.tasks.incomplete
    @task_categories = TaskCategory.for_user(current_user)
  end

  def new
    @task_category = TaskCategory.find(params[:task_category_id])
    @task = @task_category.tasks.new()
  end

  def create
    @task = current_user.tasks.create(
      task_params.merge(created_by_user_id: current_user.id)
    )
  end

  def edit
    render :new
  end

  def update
    @task.update_attributes(task_params)
  end

  def destroy
    @task.update_attribute(:is_active, false)
  end

  private

  def set_task
    @task = current_user.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :due_date, :frequency_cd,
      :weight, :task_category_id)
  end

end
