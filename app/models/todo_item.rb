# frozen_string_literal: true

class TodoItem < Task
  belongs_to :todo_list, polymorphic: true, foreign_key: "list_id", foreign_type: "list_type"
end
