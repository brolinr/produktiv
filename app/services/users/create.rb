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
        assign_data({ response: { user: UserSerializer.new(resource).serializable_hash }, resource: resource })
      else
        assign_data(
          {
            response: {
              user: UserSerializer.new(resource).serializable_hash,
              notice: I18n.t("devise.registrations.signed_up_but_#{resource.inactive_message}")
            },
            resource: resource
          }
        )
      end
    else
      assign_data({ response: { error: resource.errors.full_messages }, status: :unprocessable_entity })
    end
  rescue StandardError => e
    assign_data({ response: { error: e.message }, status: :unprocessable_entity })
  end
end
