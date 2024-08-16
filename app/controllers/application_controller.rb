# frozen_string_literal: true

class ApplicationController < ActionController::API
  # before_action :doorkeeper_authorize!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name username email password password_confimation])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name username email password password_confimation])
  end
end
