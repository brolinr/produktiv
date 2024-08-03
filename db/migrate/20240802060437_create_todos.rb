class CreateTodos < ActiveRecord::Migration[7.2]
  def change
    create_table :todos do |t|
      t.string :title, default: 'Todo List'
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
