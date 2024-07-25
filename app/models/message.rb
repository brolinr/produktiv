# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :project_user
  belongs_to :room, polymorphic: true

  has_rich_text :content

  validates :content, :title, presence: true
end
