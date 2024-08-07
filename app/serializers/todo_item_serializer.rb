# frozen_string_literal: true

class TodoItemSerializer
  include JSONAPI::Serializer
  attributes :id, :title, :deadline, :completed_at, :completed
end
