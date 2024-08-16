# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventParticipant, type: :model do
  describe 'relations' do
    it { is_expected.to belong_to(:project_user) }
    it { is_expected.to belong_to(:event) }
  end

  describe 'factories' do
    let(:event_participant) { create(:event_participant) }

    it { expect { event_participant }.to change(described_class, :count).by(1) }
  end
end
