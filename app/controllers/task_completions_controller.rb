class TaskCompletionsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_task

  def new
    @task.complete!(current_user)
  end

  def destroy
    @task.undo_completion!
    render :new
  end

  private

  def set_task
    @task = current_user.tasks.find(params[:task_id])
  end

end
