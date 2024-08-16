# frozen_string_literal: true

class V1::Projects::ApplicationController < V1::ApplicationController
  before_action :current_project
  before_action :current_project_user

  private
  def current_project
    @current_project ||=  Project.find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Project not found!" }, status: :not_found
  end

  def current_project_user
    @current_project_user ||=  current_project.project_users.accepted.find_by!(user_id: current_resource_owner.id)
  rescue ActiveRecord::RecordNotFound
    render json: { error: "You are not authorized to perform actions in this project" }, status: :unauthorized
  end
end
