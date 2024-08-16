# frozen_string_literal: true

class V1::Projects::TodoController < V1::Projects::ApplicationController
  def index
    render json: TodoSerializer.new(current_project.todo).serializable_hash, status: :found
  end

  def update
    result = Todos::Update.call(
      params: permitted_params,
      context: { todo: current_project.todo }
    )

    render json: result.response, status: result.status
  end

  private

  def permitted_params
    params.require(:todo).permit(:title)
  end
end
