# frozen_string_literal: true

FactoryBot.define do
  factory :oauth_access_grant, class: 'Doorkeeper::AccessGrant' do
    expires_in { 10.minutes }
    redirect_uri { 'http://localhost:3000' }
  end
end
