# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Todos::Update do
  subject(:call) do
    described_class.call(
      params: ActionController::Parameters.new(params).permit!,
      context: { todo: todo }
    )
  end
  let(:todo) { create(:todo) }

  describe '#call' do
    context 'when using valid params' do
      let(:params) { { title: 'New TItle' } }
      it 'should update todo', :aggregate_failures do
        expect { call }.to change(todo, :title).to(params[:title])
        expect(call).to be_success
        expect(call.data).to be_a(Todo)
        expect(call.response).to be_a(Hash)
      end
    end

    context 'with incorect attributes' do
      let(:params) { { invlid: nil } }
      it 'should return errors', :aggregate_failures do
        expect { call }.not_to change(todo, :attributes)
        expect(call).to be_failure
        expect(call.response[:error]).not_to be_empty
        expect(call.response).to be_a(Hash)
      end
    end
  end
end
