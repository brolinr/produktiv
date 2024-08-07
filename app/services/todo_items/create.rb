# frozen_string_literal: true

class TodoItems::Create < ApplicationService
  def call
    preload(:todo_list, :project_user)

    transaction do
      step(:create_todo_item)
      step(:add_assignees)
    end

    result
  end

  private

  def todo_list
    @todo_list = context[:todo_list]
  end

  def project_user
    @project_user = context[:project_user]
  end

  def create_todo_item
    todo_item = todo_list.todo_items.new(params.except(:project_user_ids))
    todo_item.project_user = project_user

    if todo_item.save
      assign_data(todo_item)
      assign_response(TodoItemSerializer.new(todo_item).serializable_hash)
    else
      add_errors(todo_item.errors.full_messages)
      assign_response({ error: result.errors })
    end
  rescue StandardError
    add_error("Something went wrong")
    assign_response({ error: result.errors })
  end

  def add_assignees
    params[:project_user_ids]&.each do |id|
      next if result.data.assignees.create(project_user_id: id)

      add_error("Something went wrong")
      assign_response({ error: result.errors })
    end
  end
end
