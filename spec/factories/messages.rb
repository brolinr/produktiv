FactoryBot.define do
  factory :message do
    title { FFaker::Lorem.word }
    content { FFaker::Lorem.paragraph }
    project_user { create(:project_user) }
    message_board { create(:message_board) }
  end
end
