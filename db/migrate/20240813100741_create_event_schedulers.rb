class CreateEventSchedulers < ActiveRecord::Migration[7.2]
  def change
    create_table :event_schedulers do |t|
      t.string :title, default: 'Event Scheduler'
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
