# frozen_string_literal: true

class TodoSerializer
  include JSONAPI::Serializer
  attributes :id, :project_id, :title
end
