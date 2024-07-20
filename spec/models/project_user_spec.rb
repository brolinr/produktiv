require 'rails_helper'

RSpec.describe ProjectUser, type: :model do
  subject { build(:project_user) }

  describe 'validations' do
    it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:project_id).with_message(' already added') }
  end
  describe 'relations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:project) }
  end

  describe 'factories' do
    let(:project_user) { create(:project_user) }

    it { expect { project_user }.to change(described_class, :count).by(1) }
  end
end
