# frozen_string_literal: true

FactoryBot.define do
  factory :chat_member do
    chat { create(:chat) }
    project_user { create(:project_user, project: chat.project) }
  end
end
