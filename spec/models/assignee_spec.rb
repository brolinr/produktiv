# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Assignee, type: :model do
  describe 'relations' do
    it { is_expected.to belong_to(:project_user) }
    it { is_expected.to belong_to(:task) }
  end

  describe 'factories' do
    let(:assignee) { create(:assignee) }

    it { expect { assignee }.to change(described_class, :count).by(1) }
  end
end
