class CreateTodoLists < ActiveRecord::Migration[7.2]
  def change
    create_table :todo_lists do |t|
      t.string :title
      t.references :todo, null: false, foreign_key: true

      t.timestamps
    end
  end
end
