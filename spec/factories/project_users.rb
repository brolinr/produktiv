FactoryBot.define do
  factory :project_user do
    role { 'member' }
    invite_status { 'pending' }
    user { create(:user) }
    project { create(:project) }
  end
end
