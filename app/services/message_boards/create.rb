class MessageBoards::Create < ApplicationService
  def call
    preload :project

    step :create_message_board

    result
  end

  private

  def project
    @project ||= context[:project]
  end

  def create_message_board
    message_board = MessageBoard.new(params)
    message_board.project = project

    if message_board.save
      assign_data(message_board)
      assign_response(MessageBoardSerializer.new(message_board).serializable_hash)
    else
      add_errors(message_board.errors.full_messages)
      assign_response({ error: result.errors })
    end
  rescue StandardError
    add_error('Something went wrong')
    assign_response({ error: result.errors })
  end
end
