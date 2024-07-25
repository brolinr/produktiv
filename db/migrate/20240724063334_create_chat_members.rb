class CreateChatMembers < ActiveRecord::Migration[7.2]
  def change
    create_table :chat_members do |t|
      t.references :chat, null: false, foreign_key: true
      t.references :project_user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
