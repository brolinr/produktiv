class V1::InvitesController < V1::ApplicationController
  before_action :invite, only: %i[show update destroy]
  before_action :project, only: %i[index create]

  def index
    render json: ProjectUserSerializer.new(project.project_users).serializable_hash, status: :ok
  end

  def show
    render json: ProjectUserSerializer.new(invite).serializable_hash, status: :ok
  end

  def create
    result = Invites::Create.call(
      params: invites_params,
      context: { project: project }
    )

    render json: result.response, status: result.status
  end

  def update
    result = Invites::Update.call(params: invite_params, context: { invite: invite })
    render json: result.response, status: result.status
  end

  def destroy
    invite.destroy
    head :no_content
  end

  private
  def invite_params
    params.require(:invite).permit(:user_id, :role, :invite_status)
  end

  def invites_params
    params.require(:invites).permit(users: [ :user_id, :role, :invite_status ])
  end

  def invite
    @invite ||= ProjectUser.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Invite not found" }, status: :not_found
  end

  def project
    @project ||= Project.find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Project not found" }, status: :not_found
  end
end
