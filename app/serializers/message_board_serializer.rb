# frozen_string_literal: true

class MessageBoardSerializer
  include JSONAPI::Serializer
  attributes :id, :project_id, :title
end
