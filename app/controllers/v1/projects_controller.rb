# frozen_string_literal: true

class V1::ProjectsController < V1::ApplicationController
  before_action :project, only: %i[show update destroy]

  def index
    projects = ProjectSerializer.new(current_resource_owner.projects).serializable_hash
    render json: projects, status: :ok
  end

  def show
    render json: ProjectSerializer.new(project), status: :ok
  end

  def create
    result = Projects::Create.call(context: { user: current_resource_owner }, params: permitted_params)

    render json: result.response, status: result.status
  end

  def update
    result = Projects::Update.call(params: permitted_params, context: { project: project })

    render json: result.response, status: result.status
  end

  def destroy
    project.destroy
    head(:no_content)
  end

  private

  def project
    @project ||= current_resource_owner.projects.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Record not found" }, status: :not_found
  end

  def permitted_params
    params.require(:project).permit(:title, :description, :user_ids)
  end
end
