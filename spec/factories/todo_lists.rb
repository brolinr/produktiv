# frozen_string_literal: true

FactoryBot.define do
  factory :todo_list do
    title { FFaker::Lorem.word }
    project_user { create(:project_user) }
    todo { create(:todo) }
    description { FFaker::Lorem.paragraph }
  end
end
