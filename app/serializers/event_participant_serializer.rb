# frozen_string_literal: true

class EventParticipantSerializer
  include JSONAPI::Serializer
  belongs_to :project_user
  belongs_to :event_scheduler
end
