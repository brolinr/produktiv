# frozen_string_literal: true

class TodoItems::Update < ApplicationService
  def call
    preload(:todo_item)

    transaction do
      step(:update_todo_item)
      step(:update_assignees)
    end

    result
  end

  private

  def todo_item
    @todo_item ||= context[:todo_item]
  end

  def update_todo_item
    if todo_item.update(params.except(:project_id, :project_user_ids))
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

  def update_assignees
    return unless params[:project_user_ids]

    existing_assignee_ids = todo_item.assignees.pluck(:project_user_id)
    new_assignee_ids = params[:project_user_ids].map(&:to_i)
    todo_item.assignees.where(project_user_id: existing_assignee_ids - new_assignee_ids).each(&:destroy!)

    (new_assignee_ids - existing_assignee_ids).each do |project_user_id|
      next if Assignee.create(task: todo_item, project_user_id: project_user_id)

      add_error("Something went wrong while adding assignees")
    end
  end
end
