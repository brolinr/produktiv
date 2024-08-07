class CreateAssignees < ActiveRecord::Migration[7.2]
  def change
    create_table :assignees do |t|
      t.references :project_user, null: false, foreign_key: true
      t.references :task, null: false, foreign_key: true

      t.timestamps
    end
  end
end
