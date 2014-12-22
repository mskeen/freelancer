class TasksController < ApplicationController
  before_filter :authenticate_user!

  def index
    @tasks = current_user.tasks
    @task_categories = TaskCategory.for_user(current_user)
  end

  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.create(task_params)
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :due_date, :frequency_cd,
      :weight)
  end

end
