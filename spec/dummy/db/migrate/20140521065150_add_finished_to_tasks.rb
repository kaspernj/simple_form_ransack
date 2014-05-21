class AddFinishedToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :finished, :boolean
  end
end
