class Message < ApplicationRecord
  belongs_to :project_user
  belongs_to :message_board

  has_rich_text :content

  validates :content, :title, presence: true
end
