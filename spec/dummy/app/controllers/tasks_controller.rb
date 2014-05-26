class TasksController < ApplicationController
  def index
    @ransack_params = params[:q] || {}
    @ransack = Task.ransack(@ransack_params)
    @tasks = @ransack.result
  end
end
