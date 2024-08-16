# frozen_string_literal: true

class Events::Update < ApplicationService
  def call
    preload(:event)

    transaction do
      step(:update_event)
      step(:update_event_participants)
    end

    result
  end

  private

  def event
    @event ||= context[:event]
  end

  def update_event
    if event.update(params.except(:project_id, :project_user_ids))
      assign_data(event)
      assign_response(EventSerializer.new(event).serializable_hash)
    else
      add_errors(event.errors.full_messages)
      assign_response({ error: result.errors })
    end
  rescue StandardError
    add_error("Something went wrong")
    assign_response({ error: result.errors })
  end

  def update_event_participants
    return unless params[:project_user_ids]

    existing_participant_ids = event.event_participants.pluck(:project_user_id)
    new_participant_ids = params[:project_user_ids].map(&:to_i)
    event.event_participants.where(project_user_id: existing_participant_ids - new_participant_ids).each(&:destroy!)

    (new_participant_ids - existing_participant_ids).each do |project_user_id|
      next if EventParticipant.create(event: event, project_user_id: project_user_id)

      add_error("Something went wrong while adding event participants")
      assign_response({ error: result.errors })
    end
  end
end
