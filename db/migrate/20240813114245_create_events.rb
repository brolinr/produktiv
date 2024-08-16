class CreateEvents < ActiveRecord::Migration[7.2]
  def change
    create_table :events do |t|
      t.string :title
      t.datetime :starts_at
      t.datetime :ends_at
      t.references :event_scheduler, null: false, foreign_key: true
      t.references :project_user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
