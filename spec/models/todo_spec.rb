# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Todo, type: :model do
  describe 'relations' do
    it { is_expected.to belong_to(:project) }
    it { is_expected.to have_many(:todo_lists).dependent(:destroy) }
  end

  describe 'factories' do
    let(:todo) { create(:todo) }

    it { expect { todo }.to change(described_class, :count).by(1) }
  end
end
