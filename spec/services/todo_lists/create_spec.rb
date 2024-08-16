# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TodoLists::Create do
  subject(:call) do
    described_class.call(
      params: ActionController::Parameters.new(params).permit!,
      context: { project: project, project_user: project_user }
    )
  end
  let(:user) { create(:user) }
  let(:project) { create(:project) }
  let(:project_user) { create(:project_user, project: project, user: user, invite_status: 'accepted') }
  let(:todo) { create(:todo, project: project) }

  describe '#call' do
    context 'when using valid params' do
      before do
        todo
      end

      let(:params) { attributes_for(:todo_list, todo: nil) }
      it 'should create todo list', :aggregate_failures do
        expect { call }.to change(TodoList, :count).by(1)
        expect(call).to be_success
        expect(call.data).to be_a(TodoList)
        expect(call.response).to be_a(Hash)
      end
    end

    context 'with invalid params' do
      let(:params) { { invalid: 'not' } }
      it 'should return errors', :aggregate_failures do
        expect { call }.not_to change(TodoList, :count).from(0)
        expect(call).to be_failure
        expect(call.response[:error]).not_to be_empty
        expect(call.response).to be_a(Hash)
      end
    end
  end
end
