class TaskCategoriesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_task_category, only: [:show]

  def new
    @task_category = current_user.task_categories.new
  end

  def create
    @task_category = current_user.task_categories.create(task_category_params)
  end

  def show
  end

  private

  def set_task_category
    @task_category = TaskCategory.for_user(current_user).find(params[:id])
  end

  def task_category_params
    params.require(:task_category).permit(:name, :is_shared)
  end
end
