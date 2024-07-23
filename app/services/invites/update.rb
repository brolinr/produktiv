class Invites::Update < ApplicationService
  def call
    preload(:invite)

    step(:update_invite)

    result
  end

  private
  def invite
    @invite ||= context[:invite]
  end

  def update_invite
    if invite.update(params)
      assign_data(invite)
      assign_response(ProjectUserSerializer.new(invite).serializable_hash)
    else
      assign_data(invite)
      add_errors(invite.errors.full_messages)
      assign_response({ error: result.errors })
    end
  rescue StandardError
    assign_data(invite) if invite
    add_error('Something went wrong')
    assign_response({ error: result.errors })
  end
end
