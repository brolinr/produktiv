# frozen_string_literal: true

class V1::TodoListsController < V1::ApplicationController
  before_action :project
  before_action :todo_list, only: %i[show update destroy]

  def index
    todo_lists = TodoListSerializer.new(project.todo.todo_lists).serializable_hash
    render json: todo_lists, status: :ok
  end

  def show
    render json: TodoListSerializer.new(todo_list), status: :ok
  end

  def create
    result = TodoLists::Create.call(context: { project: project }, params: permitted_params)
    render json: result.response, status: result.status
  end

  def update
    result = TodoLists::Update.call(params: permitted_params, context: { todo_list: todo_list })

    render json: result.response, status: result.status
  end

  def destroy
    todo_list.destroy
    head(:no_content)
  end

  private

  def todo_list
    @todo_list ||= project.todo.todo_lists.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Todo list not found" }, status: :not_found
  end

  def project
    @project ||= current_resource_owner.project_users.find_by!(project_id: params[:project_id]).project
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Project not found" }, status: :not_found
  end

  def permitted_params
    params.require(:todo_list).permit(:title, :description)
  end
end
