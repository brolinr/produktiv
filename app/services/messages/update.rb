# frozen_string_literal: true

class Messages::Update < ApplicationService
  def call
    preload :message

    step :update_message

    result
  end

  private
  def message
    @message ||= context[:message]
  end

  def update_message
    if message.update(params)
      assign_data(message)
      assign_response(MessageSerializer.new(message).serializable_hash)
    else
      add_errors(message.errors.full_messages)
      assign_response({ error: result.errors })
    end
  rescue StandardError
    add_error("Something went wrong")
    assign_response({ error: result.errors })
  end
end
