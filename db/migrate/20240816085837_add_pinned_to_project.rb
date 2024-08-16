class AddPinnedToProject < ActiveRecord::Migration[7.2]
  def change
    add_column :projects, :pinned, :boolean
  end
end
