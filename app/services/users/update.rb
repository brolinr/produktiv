# frozen_string_literal: true

class Users::Update < ApplicationService
  def call
    preload :user

    step :update_user

    result
  end

  private

  def user
    @user ||= context[:user]
  end

  def update_user
    return add_error("Login to update account") if user.nil?

    if user.update(params)
      assign_response(UserSerializer.new(user).serializable_hash)
    else
      add_errors(user.errors.full_messages)
      assign_response({ error: result.errors })
    end
assign_data(user)
  rescue StandardError => e
    add_errors(e)
    assign_response({ error: result.errors })
  end
end
