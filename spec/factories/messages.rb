# frozen_string_literal: true

FactoryBot.define do
  factory :message do
    title { FFaker::Lorem.word }
    content { FFaker::Lorem.paragraph }
    project_user { create(:project_user) }
    room { create(:message_board) }
  end
end
