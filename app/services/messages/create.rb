# frozen_string_literal: true

class Messages::Create < ApplicationService
  def call
    preload :project, :user, :sender

    step :create_message

    result
  end

  private

  def project
    @project ||= context[:project]
  end

  def user
    @user ||= context[:user]
  end

  def project_user
    ProjectUser.accepted.find_by(user: user, project: project)
  end

  def sender
    @sender ||= case params[:sender_type]
    when "ProjectUser"
      project_user
    when "ChatMember"
      user.chat_members.find_by(id: params[:sender_id])
    end
  end

  def room
    @room ||= case params[:room_type]
    when "Chat"
      project.chats.find_by(id: params[:room_id])
    when "MessageBoard"
      project.message_board
    when "TodoItem", "Task"
      Task.find_by(id: params[:room_id])
    else
      add_error("Room not found")
    end
  end

  def create_message
    message = Message.new(params)
    message.room = room
    message.sender = sender

    if message.save
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
