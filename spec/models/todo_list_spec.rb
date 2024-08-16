# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TodoList, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:description) }
  end

  describe 'relations' do
    it { is_expected.to belong_to(:todo) }
    it { is_expected.to belong_to(:project_user) }
    it { is_expected.to have_many(:todo_items).dependent(:destroy) }
  end

  describe 'factories' do
    let(:todo_list) { create(:todo_list) }

    it { expect { todo_list }.to change(described_class, :count).by(1) }
  end
end
