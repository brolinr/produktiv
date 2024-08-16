# frozen_string_literal: true

class V1::Projects::TodoListsController < V1::Projects::ApplicationController
  before_action :todo_list, only: %i[show update destroy]

  def index
    todo_lists = TodoListSerializer.new(current_project.todo_lists).serializable_hash
    render json: todo_lists, status: :ok
  end

  def show
    render json: TodoListSerializer.new(todo_list), status: :ok
  end

  def create
    result = TodoLists::Create.call(
      context: {
        project: current_project,
        project_user: current_project_user
      },
      params: permitted_params
    )

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
    @todo_list ||= current_project.todo.todo_lists.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Todo list not found" }, status: :not_found
  end

  def permitted_params
    params.require(:todo_list).permit(:title, :description)
  end
end
