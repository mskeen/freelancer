class TasksController < ApplicationController
  before_filter :authenticate_user!

  def index
    @tasks = current_user.tasks
    @task_categories = current_user.task_categories
  end

end
