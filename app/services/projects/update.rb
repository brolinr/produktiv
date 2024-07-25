# frozen_string_literal: true

class Projects::Update < ApplicationService
  def call
    preload :project

    step :update_projects

    result
  end

  private
  def project
    @project ||= context[:project]
  end

  def update_projects
    if project.update(params.except(:user_ids))
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
