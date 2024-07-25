# frozen_string_literal: true

FactoryBot.define do
  factory :application, class: 'Doorkeeper::Application' do
    name { 'Test Application' }
    redirect_uri { 'https://app.com/callback' }
    scopes { 'public' }
  end
end
