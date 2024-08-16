# frozen_string_literal: true

FactoryBot.define do
  factory :event_scheduler do
    title { "Event scheduler" }
    project { create(:project) }
  end
end
