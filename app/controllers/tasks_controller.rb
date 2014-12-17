class TasksController < ApplicationController
  before_filter :authenticate_user!

  def index
    @tasks = current_user.tasks
    @task_categories = TaskCategory.for_user(current_user)
  end

end
