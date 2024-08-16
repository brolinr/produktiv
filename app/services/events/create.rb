# frozen_string_literal: true

class Events::Create < ApplicationService
  def call
    preload(:project, :project_user)

    transaction do
      step(:create_event)
      step(:add_participants)
    end

    result
  end

  private



  def project
    @project ||= context[:project]
  end

  def project_user
    @project_user ||= context[:project_user]
  end

  def create_event
    @event = project_user.events.build(params.except(:project_user_ids))
    @event.event_scheduler = project.event_scheduler
    if @event.save
      assign_data(@event)
      assign_response(EventSerializer.new(@event).serializable_hash)
    else
      add_errors(@event.errors.full_messages)
      assign_response({ error: result.errors })
    end
  rescue StandardError
    add_error("Something went wrong")
    assign_response({ error: result.errors })
  end

  def add_participants
    params[:project_user_ids]&.each do |project_user_id|
      next if EventParticipant.create(project_user_id: project_user_id, event: @event)

      add_error("Something went wrong adding a participant")
      assign_response({ error: result.errors })
    end
  end
end
