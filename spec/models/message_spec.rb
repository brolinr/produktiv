require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_presence_of(:title) }
  end

  describe 'relations' do
    it { is_expected.to belong_to(:message_board) }
    it { is_expected.to belong_to(:project_user) }
  end

  describe 'factories' do
    let(:message) { create(:message) }

    it { expect { message }.to change(described_class, :count).by(1) }
  end
end
