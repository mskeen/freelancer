class TasksController < ApplicationController
  before_filter :authenticate_user!

  def index
    @tasks = current_user.tasks
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

  private

  def task_params
    params.require(:task).permit(:title, :description, :due_date, :frequency_cd,
      :weight, :task_category_id)
  end

end
