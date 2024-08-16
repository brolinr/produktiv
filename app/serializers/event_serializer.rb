# frozen_string_literal: true

class EventSerializer
  include JSONAPI::Serializer
  attributes :title, :starts_at, :ends_at, :project_user, :messages
end
