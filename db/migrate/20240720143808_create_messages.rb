class CreateMessages < ActiveRecord::Migration[7.2]
  def change
    create_table :messages do |t|
      t.string :title
      t.references :project_user, null: false, foreign_key: true
      t.references :room, null: false, polymorphic: true

      t.timestamps
    end
  end
end
