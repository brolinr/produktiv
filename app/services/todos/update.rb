# frozen_string_literal: true

class Todos::Update < ApplicationService
  def call
    preload(:project, :todo)

    step(:update_todo)

    result
  end

  private

  def project
    @project ||= context[:project]
  end

  def todo
    @todo ||= context[:todo] || project.todo
  end

  def update_todo
    if todo.update(params.except(:project_id))
      assign_data(todo)
      assign_response(TodoSerializer.new(todo).serializable_hash)
    else
      add_errors(todo.errors.full_messages)
      assign_response({ error: result.errors })
    end
  rescue StandardError
    add_error("Something went wrong")
    assign_response({ error: result.errors })
  end
end
