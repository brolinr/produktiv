# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventScheduler, type: :model do
  describe 'relations' do
    it { is_expected.to belong_to(:project) }
    it { is_expected.to have_many(:events).dependent(:destroy) }
  end

  describe 'factories' do
    let(:event_scheduler) { create(:event_scheduler) }

    it { expect { event_scheduler }.to change(described_class, :count).by(1) }
  end
end
