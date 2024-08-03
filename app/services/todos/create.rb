# frozen_string_literal: true

class Todos::Create < ApplicationService
  def call
    preload(:project)

    step(:create_todo)

    result
  end

  private

  def project
    @project ||= context[:project]
  end

  def create_todo
    todo = Todo.new(params)
    todo.project = project

    if todo.save
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
