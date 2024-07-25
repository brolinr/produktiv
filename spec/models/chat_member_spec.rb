# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChatMember, type: :model do
  subject { build(:chat_member) }

  describe 'validations' do
    it { is_expected.to validate_uniqueness_of(:project_user_id).scoped_to(:chat_id) }
  end

  describe 'relations' do
    it { is_expected.to belong_to(:chat) }
    it { is_expected.to belong_to(:project_user) }
    it { is_expected.to have_many(:messages).dependent(:destroy) }
  end

  describe 'factories' do
    let(:chat_member) { create(:chat_member) }

    it { expect { chat_member }.to change(described_class, :count).by(1) }
  end
end
