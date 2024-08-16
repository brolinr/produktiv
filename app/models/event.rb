# frozen_string_literal: true

class Event < ApplicationRecord
  belongs_to :event_scheduler
  belongs_to :project_user

  has_rich_text :description
  has_many :event_participants, dependent: :destroy
  has_many :messages, dependent: :destroy, as: :room

  validates :title, :description, presence: true
end
