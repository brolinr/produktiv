class Users::Create < ApplicationService
  def call
    step(:create_user)

    result
  end

  private

  def create_user
    resource = User.new_with_session(params, context[:session])

    resource.save
    if resource.persisted?
      if resource.active_for_authentication?
        assign_data(resource)
        assign_response({ user: UserSerializer.new(resource).serializable_hash })
      else
        assign_data(resource)
        assign_response(
          user: UserSerializer.new(resource).serializable_hash,
          notice: I18n.t("devise.registrations.signed_up_but_#{resource.inactive_message}")
        )
      end
    else
      add_errors(resource.errors.full_messages)
      assign_response({ error: result.errors })
    end
  rescue StandardError => e
    add_errors(e.message)
    assign_response({ error: result.errors })
  end
end
