class ApplicationController < ActionController::API
  # before_action :doorkeeper_authorize!
  before_action :configure_permitted_parameters, if: :devise_controller?

  # include ::ActionController::Caching
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  # self.cache_store = :mem_cache_store
  # example caching
  # def show
  #   @post = Post.find(params[:id])

  #   if stale?(last_modified: @post.updated_at)
  #     render json: @post
  #   end
  # end
  #


  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name username email password password_confimation])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name username email password password_confimation])
  end
end
