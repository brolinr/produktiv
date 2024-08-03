# frozen_string_literal: true

FactoryBot.define do
  factory :todo do
    title { 'Todo List' }
    project { create(:project) }
  end
end
