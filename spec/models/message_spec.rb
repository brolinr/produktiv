# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:content) }
  end

  describe 'relations' do
    it { is_expected.to belong_to(:room) }
    it { is_expected.to belong_to(:sender) }
  end

  describe 'factories' do
    let(:message) { create(:message) }

    it { expect { message }.to change(described_class, :count).by(1) }
  end
end
