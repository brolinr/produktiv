# frozen_string_literal: true

class TodoListSerializer
  include JSONAPI::Serializer
  attributes :id, :title, :description
  has_many :todo_items, serializer: ::TodoItemSerializer
end
