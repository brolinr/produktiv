# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
  end

  describe 'relations' do
    it { is_expected.to belong_to(:list) }
    it { is_expected.to belong_to(:project_user) }
    it { is_expected.to have_many(:assignees).dependent(:destroy) }
    it { is_expected.to have_many(:messages).dependent(:destroy) }
  end

  describe 'factories' do
    let(:task) { create(:task) }

    it { expect { task }.to change(described_class, :count).by(1) }
  end
end
