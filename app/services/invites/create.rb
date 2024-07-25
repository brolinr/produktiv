# frozen_string_literal: true

class Invites::Create < ApplicationService
  def call
    preload :project

    transaction do
      step :multiple
      # step :send_email
    end

    step :set_response

    result
  end

  private

  def project
    @project ||= context[:project]
  end

  def multiple
    @invites = []

    params&.dig(:users).each do |invite_params|
      send_invite_request(invite_params)
    end
  end

  def send_invite_request(invite_params)
    invite = project.project_users.build(invite_params)
    if invite.save
      @invites << invite
    else
      add_errors(invite.errors.full_messages)
      assign_response({ error: "Something went wrong! Try again" })
    end

  rescue StandardError
    add_error("Something went wrong")
    assign_response({ error: result.errors })
  end

  def set_response
    assign_data(@invites)
    assign_response(ProjectUserSerializer.new(@invites).serializable_hash) if @invites.any?
  end

  # TODO: ADD LOGIC FOR SENDING INVITE EMAIL
  # def send_email
  # end
end
