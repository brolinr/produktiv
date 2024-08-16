# frozen_string_literal: true

class V1::Projects::MessageBoardController < V1::Projects::ApplicationController
  def index
    render json: MessageBoardSerializer.new(current_project.message_board).serializable_hash, status: :found
  end

  def update
    result = MessageBoards::Update.call(
      params: permitted_params,
      context: { message_board: current_project.message_board }
    )

    render json: result.response, status: result.status
  end

  private
  def permitted_params
    params.require(:message_board).permit(:title)
  end
end
