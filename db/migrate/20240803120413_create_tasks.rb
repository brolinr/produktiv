class CreateTasks < ActiveRecord::Migration[7.2]
  def change
    create_table :tasks do |t|
      t.string :title
      t.jsonb :additional_fields
      t.boolean :completed
      t.datetime :deadline
      t.datetime :completed_at
      t.references :list, null: false, polymorphic: true
      t.references :project_user, null: false, foreign_key: true
      t.string :type

      t.timestamps
    end
  end
end
