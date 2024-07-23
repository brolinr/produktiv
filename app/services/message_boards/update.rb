class MessageBoards::Update < ApplicationService
  def call
    preload :message_board

    step :update_message_board

    result
  end

  private
  def message_board
    @message_board ||= context[:message_board]
  end

  def update_message_board
    if message_board.update(params.except(:project_id))
      assign_data(message_board)
      assign_response MessageBoardSerializer.new(message_board).serializable_hash
    else
      add_errors(message_board.errors.full_messages)
      assign_response({ error: result.errors })
    end
  rescue StandardError
    add_error('Something went wrong')
    assign_response({ error: result.errors })
  end
end
