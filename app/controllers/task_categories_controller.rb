class TaskCategoriesController < ApplicationController
  before_filter :authenticate_user!

  def new
    @task_category = current_user.task_categories.new
  end

  def create
    @task_category = current_user.task_categories.create(
      task_category_params.merge(organization: current_user.organization)
    )
  end

  private

  def task_category_params
    params.require(:task_category).permit(:name, :is_shared)
  end
end
