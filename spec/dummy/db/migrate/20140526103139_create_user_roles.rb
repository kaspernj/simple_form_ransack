class CreateUserRoles < ActiveRecord::Migration
  def change
    create_table :user_roles do |t|
      t.integer :user_id
      t.string :role
    end

    add_index :user_roles, :user_id
  end
end
