module V1Helpers
  def authenticate_with_token(user)
    application = create(:application)
    token = create(:access_token, resource_owner_id: user.id, application: application)
    { 'Authorization' => "Bearer #{token.token}" }
  end
end
