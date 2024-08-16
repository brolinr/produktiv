# frozen_string_literal: true

class V1::EventsController < V1::ApplicationController
  before_action :project
  before_action :event, only: %i[show update destroy]

  def index
    events = EventSerializer.new(project.events).serializable_hash
    render json: events, status: :ok
  end

  def show
    render json: EventSerializer.new(event), status: :ok
  end

  def create
    result = Events::Create.call(
      context: { user: current_resource_owner, project: project },
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

  def project
    @project ||= Project.find_by(id: params[:project_id])
  end

  def event
    @event ||= project.events.find(params[:id])
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
