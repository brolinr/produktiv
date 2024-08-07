# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    title { FFaker::Lorem.sentence }
    additional_fields { "" }
    completed { false }
    deadline { "2024-08-03 14:04:13" }
    completed_at { "2024-08-03 14:04:13" }
    list { create(:todo_list) }
    project_user { create(:project_user) }
  end
end
