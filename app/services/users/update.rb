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
      assign_data(user)
    else
      add_errors(user.errors.full_messages)
      assign_response({ error: result.errors })
      assign_data(user)
    end
  rescue StandardError => e
    add_errors(e)
    assign_response({ error: result.errors })
  end
end
