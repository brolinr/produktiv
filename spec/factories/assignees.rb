# frozen_string_literal: true

FactoryBot.define do
  factory :assignee do
    project_user { create(:project_user) }
    task { create(:task) }
  end
end
