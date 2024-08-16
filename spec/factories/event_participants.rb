# frozen_string_literal: true

FactoryBot.define do
  factory :event_participant do
    event { create(:event) }
    project_user { create(:project_user) }
  end
end
