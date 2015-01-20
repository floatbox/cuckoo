class TasksController < ApplicationController

  # GET /tasks
  def index
    @tasks = Task.order('created_at DESC').limit(20)
  end

end
