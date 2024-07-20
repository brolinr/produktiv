class Projects::Create < ApplicationService
  def call
    preload :user

    step :create_project

    result
  end

  private
  def user
    @user ||= context[:user]
  end

  def create_project
    project = user.projects.create(params)

    if project.save
      assign_data(project)
      assign_response(ProjectSerializer.new(project).serializable_hash)
    else
      add_errors(project.errors.full_messages)
      assign_response({ error: result.errors })
    end
  rescue StandardError
    add_error("Something went wrong")
    assign_response({ error: result.errors })
  end
end
