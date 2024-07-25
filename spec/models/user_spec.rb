# frozen_string_literal: true

require 'rails_helper'


RSpec.describe User, type: :model do
  subject { build(:user) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_presence_of(:email) }
    pending { should validate_uniqueness_of(:username).case_insensitive }
    it { should validate_uniqueness_of(:email).case_insensitive }
  end

  describe 'relations' do
    it { is_expected.to have_many(:project_users).dependent(:destroy) }
    it { is_expected.to have_many(:projects).dependent(:destroy) }
    # it { is_expected.to have_many(:messages).through(:project_user) }
  end

  describe 'factories' do
    let(:user) { create(:user) }

    it { expect { user }.to change(described_class, :count).by(1) }
  end
end
