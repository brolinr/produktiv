# frozen_string_literal: true

FactoryBot.define do
  factory :todo_list do
    title { FFaker::Lorem.word }
    todo { create(:todo) }
    description { FFaker::Lorem.paragraph }
  end
end
