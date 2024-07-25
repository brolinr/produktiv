# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MessageBoard, type: :model do
  describe 'relations' do
    it { is_expected.to belong_to(:project) }
    it { is_expected.to have_many(:messages) }
  end

  describe 'factories' do
    let(:message_board) { create(:message_board) }

    it { expect { message_board }.to change(described_class, :count).by(1) }
  end
end
