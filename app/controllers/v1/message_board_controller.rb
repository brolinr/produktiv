class V1::MessageBoardController < V1::ApplicationController
  before_action :project

  def index
    render json: MessageBoardSerializer.new(project.message_board).serializable_hash, status: :found
  end

  def update
    result = MessageBoards::Update.call(
      params: permitted_params,
      context: { message_board: project.message_board }
    )

    render json: result.response, status: result.status
  end

  private

  def project
    @project ||= Project.find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Project not found' }, status: :not_found
  end

  def permitted_params
    params.require(:message_board).permit(:title)
  end
end
