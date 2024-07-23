class Messages::Create < ApplicationService
  def call
    preload :project, :user, :project_user

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
    @project_user ||= user.project_users.find_by(project: project)
  end

  def create_message
    message = Message.new(params)
    message.message_board = project.message_board
    message.project_user = project_user

    if message.save
      assign_data(message)
      assign_response(MessageSerializer.new(message).serializable_hash)
    else
      add_errors(message.errors.full_messages)
      assign_response({ error: result.errors })
    end
  rescue StandardError
    add_error('Something went wrong')
    assign_response({ error: result.errors })
  end
end
