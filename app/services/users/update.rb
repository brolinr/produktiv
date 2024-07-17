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
      assign_data({ response: { user: UserSerializer.new(user).serializable_hash }, resource: user })
    else
      assign_data({ response: { error: user.errors.full_messages }, status: :unprocessable_entity })
    end
  rescue StandardError => e
    assign_data({ response: { error: e.message }, status: :unprocessable_entity })
  end
end
