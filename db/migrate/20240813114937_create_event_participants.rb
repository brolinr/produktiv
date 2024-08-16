class CreateEventParticipants < ActiveRecord::Migration[7.2]
  def change
    create_table :event_participants do |t|
      t.references :event, null: false, foreign_key: true
      t.references :project_user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
