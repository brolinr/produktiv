# frozen_string_literal: true

class V1::ChatsController < V1::ApplicationController
  before_action :project
  before_action :chat, only: %i[show destroy]
  def index
    chats = current_resource_owner.chats.where(project: project)
    render json: ChatSerializer.new(chats).serializable_hash, status: :found
  end

  def show
    render json: ChatSerializer.new(chat).serializable_hash, status: :found
  end

  def create
    result = Chats::Create.call(params: permitted_params, context: { project: project })
    render json: result.response, status: result.status
  end

  def destroy
    chat.destroy!
    head(:no_content)
  end

  private

  def project
   @project ||= Project.find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Project not found" }, status: :not_found
  end

  def chat
    @chat ||= current_resource_owner.chats.where(project: project).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Chat not found" }, status: :not_found
  end

  def permitted_params
    params.require(:chat).permit(project_users: [])
  end
end
