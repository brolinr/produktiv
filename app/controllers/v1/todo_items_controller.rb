# frozen_string_literal: true

class V1::TodoItemsController < V1::ApplicationController
  before_action :project_user
  before_action :project
  before_action :todo_list
  before_action :todo_item, only: %i[show update destroy]

  def index
    todo_items = TodoItemSerializer.new(todo_list.todo_items).serializable_hash
    render json: todo_items, status: :ok
  end

  def show
    render json: TodoItemSerializer.new(todo_item), status: :ok
  end

  def create
    result = TodoItems::Create.call(
      context: { todo_list: todo_list, project_user: project_user },
      params: permitted_params
    )

    render json: result.response, status: result.status
  end

  def update
    result = TodoItems::Update.call(params: permitted_params, context: { todo_item: todo_item })

    render json: result.response, status: result.status
  end

  def destroy
    todo_item.destroy!
    head(:no_content)
  end

  private

  def project_user
    @project_user = current_resource_owner.project_users.find_by!(project_id: params[:project_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "User is not authorized in this project" }, status: :not_authorized
  end

  def project
    @project ||= project_user.project
  end

  def todo_list
    @todo_list ||= project.todo_lists.find(params[:todo_list_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Todo list not found" }, status: :not_found
  end

  def todo_item
    @todo_item ||= todo_list.todo_items.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Todo item not found" }, status: :not_found
  end

  def permitted_params
    params.require(:todo_item).permit(
      :title,
      :description,
      :completed,
      :deadline,
      :completed_at,
      project_user_ids: []
    )
  end
end
