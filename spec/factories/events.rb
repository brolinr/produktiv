# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    title { FFaker::Lorem.sentence }
    description { FFaker::Lorem.paragraph }
    starts_at { Time.zone.now }
    ends_at { Time.zone.now + 2.days }
    event_scheduler { create(:event_scheduler) }
    project_user { create(:project_user) }
  end
end
