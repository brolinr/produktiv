# frozen_string_literal: true

class V1::TodoController < V1::ApplicationController
  before_action :project

  def index
    render json: TodoSerializer.new(project.todo).serializable_hash, status: :found
  end

  def update
    result = Todos::Update.call(
      params: permitted_params,
      context: { todo: project.todo }
    )

    render json: result.response, status: result.status
  end

  private

  def project
    @project ||= Project.find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Project not found" }, status: :not_found
  end

  def permitted_params
    params.require(:todo).permit(:title)
  end
end
