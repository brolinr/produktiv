# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:description) }
  end

  describe 'relations' do
    it { is_expected.to belong_to(:project_user) }
    it { is_expected.to belong_to(:event_scheduler) }
    it { is_expected.to have_many(:event_participants).dependent(:destroy) }
    it { is_expected.to have_many(:messages).dependent(:destroy) }
  end

  describe 'factories' do
    let(:event) { create(:event) }

    it { expect { event }.to change(described_class, :count).by(1) }
  end
end
