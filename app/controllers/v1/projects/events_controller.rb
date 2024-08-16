# frozen_string_literal: true

class V1::Projects::EventsController < V1::Projects::ApplicationController
  before_action :event, only: %i[show update destroy]

  def index
    events = EventSerializer.new(current_project.events).serializable_hash

    render json: events, status: :ok
  end

  def show
    render json: EventSerializer.new(event), status: :ok
  end

  def create
    result = Events::Create.call(
      context: { project_user: current_project_user, project: current_project },
      params: permitted_params
    )

    render json: result.response, status: result.status
  end

  def update
    result = Events::Update.call(params: permitted_params, context: { event: event })

    render json: result.response, status: result.status
  end

  def destroy
    event.destroy!
    head(:no_content)
  end

  private

  def event
    @event ||= current_project.events.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Event not found" }, status: :not_found
  end

  def permitted_params
    params.require(:event).permit(
      :title,
      :description,
      :starts_at,
      :ends_at,
      project_user_ids: []
    )
  end
end
