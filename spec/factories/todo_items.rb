# frozen_string_literal: true

FactoryBot.define do
  factory :todo_item do
    title { FFaker::Lorem.word }
    completed { false }
    deadline { Time.current }
    completed_at { Time.current + 2.days }
    todo_list { create(:todo_list) }
    project_user { create(:project_user) }
  end
end
