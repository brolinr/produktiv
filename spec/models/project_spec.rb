# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project, type: :model do
  subject { build(:project) }
  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:description) }
  end

  describe 'relations' do
    it { is_expected.to belong_to(:user).dependent(:destroy) }
    it { is_expected.to have_many(:project_users).dependent(:destroy) }
    it { is_expected.to have_one(:message_board).dependent(:destroy) }
    it { is_expected.to have_one(:todo).dependent(:destroy) }
    it { is_expected.to have_one(:event_scheduler).dependent(:destroy) }
    # it { is_expected.to have_many(:messages).through(:project_users) }
  end

  describe 'factories' do
    let(:project) { create(:project) }

    it { expect { project }.to change(described_class, :count).by(1) }
  end
end
