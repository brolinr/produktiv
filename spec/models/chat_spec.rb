# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Chat, type: :model do
  describe 'relations' do
    it { is_expected.to belong_to(:project) }
    it { is_expected.to have_many(:chat_members).dependent(:destroy) }
  end

  describe 'factories' do
    let(:chat) { create(:chat) }

    it { expect { chat }.to change(described_class, :count).by(1) }
  end
end
