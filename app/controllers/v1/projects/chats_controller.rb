# frozen_string_literal: true

class V1::Projects::ChatsController < V1::Projects::ApplicationController
  before_action :chat, only: %i[show destroy]

  def index
    chats = current_project_user.chats.where(project: current_project)
    render json: ChatSerializer.new(chats).serializable_hash, status: :found
  end

  def show
    render json: ChatSerializer.new(chat).serializable_hash, status: :found
  end

  def create
    result = Chats::Create.call(params: permitted_params, context: { project: current_project })

    render json: result.response, status: result.status
  end

  def destroy
    chat.destroy!
    head(:no_content)
  end

  private

  def chat
    @chat ||= current_project_user.chats.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Chat not found" }, status: :not_found
  end

  def permitted_params
    params.require(:chat).permit(project_users: [])
  end
end
