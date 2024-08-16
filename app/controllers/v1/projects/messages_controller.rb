# frozen_string_literal: true

class V1::Projects::MessagesController < V1::Projects::ApplicationController
  before_action :message, only: %i[show update destroy]

  def index
    messages = current_project.message_board.messages
    render json: MessageSerializer.new(messages).serializable_hash, status: :ok
  end

  def show
    render json: MessageSerializer.new(message).serializable_hash, status: :ok
  end

  def create
    result = Messages::Create.call(
      params: permitted_params,
      context: { project: current_project, project_user: current_project_user }
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

  def message
    @message ||= Message.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Message not found" }, status: :not_found
  end
end
