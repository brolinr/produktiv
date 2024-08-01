# frozen_string_literal: true

class Chats::Create < ApplicationService
  def call
    preload :project

    transaction do
      step :create_chat
      step :add_chat_members
    end

    step :set_response

    result
  end

  private

  def project
    @project ||= context[:project]
  end

  def create_chat
    @chat = project.chats.create
  end

  def add_chat_members
    params&.dig(:project_users).each do |project_user_id|
      member = @chat.chat_members.build(project_user_id: project_user_id)

      next if member.save

      add_errors(member.errors.full_messages)
      assign_response({ error: "Something went wrong! Try again" })
    end
  end

  def set_response
    assign_data(@chat)
    assign_response(ChatSerializer.new(@chat).serializable_hash)
  end
end
