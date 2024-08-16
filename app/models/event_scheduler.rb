# frozen_string_literal: true

class EventScheduler < ApplicationRecord
  belongs_to :project
  has_many :events, dependent: :destroy
end
