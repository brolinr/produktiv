# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TodoLists::Update do
  subject(:call) do
    described_class.call(
      params: ActionController::Parameters.new(params).permit!,
      context: { todo_list: todo_list }
    )
  end
  let(:todo_list) { create(:todo_list) }

  describe '#call' do
    context 'when using valid params' do
      let(:params) { { title: 'New TItle' } }
      it 'should update todo_list', :aggregate_failures do
        expect { call }.to change(todo_list, :title).to(params[:title])
        expect(call).to be_success
        expect(call.data).to be_a(TodoList)
        expect(call.response).to be_a(Hash)
      end
    end

    context 'with incorect attributes' do
      let(:params) { { invlid: nil } }
      it 'should return errors', :aggregate_failures do
        expect { call }.not_to change(todo_list, :attributes)
        expect(call).to be_failure
        expect(call.response[:error]).not_to be_empty
        expect(call.response).to be_a(Hash)
      end
    end
  end
end
