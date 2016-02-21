class TasksController < ApplicationController
  def index
    @ransack_params = params[:q] || {}
    set_default_arguments if params[:set_default_arguments]
    @ransack = Task.ransack(@ransack_params)
    @tasks = @ransack.result
  end

private

  def set_default_arguments
    @ransack_params[:name_cont] = "Test sample cont"
  end
end
