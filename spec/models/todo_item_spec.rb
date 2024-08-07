# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TodoItem, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
  end

  describe 'relations' do
    it { is_expected.to belong_to(:todo_list) }
    it { is_expected.to belong_to(:project_user) }
    it { is_expected.to have_many(:assignees).dependent(:destroy) }
    it { is_expected.to have_many(:messages).dependent(:destroy) }
  end

  describe 'factories' do
    let(:todo_item) { create(:todo_item) }

    it { expect { todo_item }.to change(described_class, :count).by(1) }
  end
end
