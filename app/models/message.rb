# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :sender, polymorphic: true
  belongs_to :room, polymorphic: true

  has_rich_text :content

  validates :content, presence: true
end
