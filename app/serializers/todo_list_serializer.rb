# frozen_string_literal: true

class TodoListSerializer
  include JSONAPI::Serializer
  attributes :id, :title, :description
end
