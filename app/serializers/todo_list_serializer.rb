# frozen_string_literal: true

class TodoListSerializer
  include JSONAPI::Serializer
  attributes :id, :title, :description, :todo_items
  # has_many :todo_items, serializer: ::TodoItemSerializer
end
