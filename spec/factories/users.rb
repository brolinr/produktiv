# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { FFaker::Name.name }
    username { FFaker::Internet.user_name }
    email { FFaker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
