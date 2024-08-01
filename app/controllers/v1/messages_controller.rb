# frozen_string_literal: true

class V1::MessagesController < V1::ApplicationController
  before_action :project, only: %i[index create]
  before_action :message, only: %i[show update destroy]
  before_action :project_user, only: %i[index create]

  def index
    messages = project.message_board.messages
    render json: MessageSerializer.new(messages).serializable_hash, status: :ok
  end

  def show
    render json: MessageSerializer.new(message).serializable_hash, status: :ok
  end

  def create
    result = Messages::Create.call(
      params: permitted_params,
      context: { project: project, user: current_resource_owner }
    )

    render json: result.response, status: result.status
  end

  def update
    result = Messages::Update.call(params: permitted_params, context: { message: message })
    render json: result.response, status: result.status
  end

  def destroy
    message.destroy
    head(:no_content)
  end

  private
  def permitted_params
    params.require(:message).permit(:title, :content, :draft, :room_id, :room_type, :sender_type, :sender_id)
  end

  def project
    @project ||= Project.find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Project not found" }, status: :not_found
  end

  def project_user
    @project_user ||= current_resource_owner.project_users.accepted.find_by(project: project)
  end

  def message
    @message ||= Message.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Message not found" }, status: :not_found
  end
end
