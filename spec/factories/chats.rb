# frozen_string_literal: true

FactoryBot.define do
  factory :chat do
    project { create(:project) }
  end
end
