class Projects::Create < ApplicationService
  def call
    preload :user

    transaction do
      step :create_project
      step :create_message_board
    end

    result
  end

  private
  def user
    @user ||= context[:user]
  end

  def create_project
    @project = user.projects.create(params)

    if @project.save
      assign_data(@project)
      assign_response(ProjectSerializer.new(@project).serializable_hash)
    else
      add_errors(@project.errors.full_messages)
      assign_response({ error: result.errors })
    end
  rescue StandardError
    add_error('Something went wrong')
    assign_response({ error: result.errors })
  end

  def create_message_board
    result = MessageBoards::Create.call(context: { project: @project })

    add_errors('Something went wrong!') if result.failure?
  end
end
