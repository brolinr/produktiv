class AddProjectUserToTodoList < ActiveRecord::Migration[7.2]
  def change
    add_reference :todo_lists, :project_user, null: false, foreign_key: true
  end
end
