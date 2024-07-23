class AddDraftToMessages < ActiveRecord::Migration[7.2]
  def change
    add_column :messages, :draft, :boolean, default: false
  end
end
