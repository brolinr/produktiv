# frozen_string_literal: true

class EventParticipant < ApplicationRecord
  belongs_to :event
  belongs_to :project_user
end
