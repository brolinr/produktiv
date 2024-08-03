# frozen_string_literal: true

class TodoLists::Update < ApplicationService
  def call
    preload(:project, :todo_list)

    step(:update_todo_list)

    result
  end

  private

  def project
    @project ||= context[:project]
  end

  def todo_list
    @todo_list ||= context[:todo_list] || project.todo_list
  end

  def update_todo_list
    if todo_list.update(params.except(:project_id))
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
