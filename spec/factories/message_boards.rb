# frozen_string_literal: true

FactoryBot.define do
  factory :message_board do
    title { "Message Board" }
    project { create(:project) }
  end
end
