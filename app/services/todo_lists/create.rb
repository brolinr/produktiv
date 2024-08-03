# frozen_string_literal: true

class TodoLists::Create < ApplicationService
  def call
    preload(:project, :todo)

    step(:create_todo_list)
    # step(:add_todo_items)

    result
  end

  private

  def project
    @project = context[:project]
  end

  def todo
    @todo = context[:todo] || project.todo
  end

  def create_todo_list
    todo_list = TodoList.new(params)
    todo_list.todo = todo

    if todo_list.save
      assign_data(todo_list)
      assign_response(TodoListSerializer.new(todo_list).serializable_hash)
    else
      add_errors(todo_list.errors.full_messages)
      assign_response({ error: result.errors })
    end
  rescue StandardError
    add_error("Something went wrong")
    assign_response({ error: result.errors })
  end
end
