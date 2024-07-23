FactoryBot.define do
  factory :message_board do
    title { "Message Board" }
    project { create(:project) }
  end
end
