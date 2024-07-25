# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MessageBoards::Create do
  subject(:call) do
    described_class.call(
      params: ActionController::Parameters.new(params).permit!,
      context: { project: project }
    )
  end
  let(:user) { create(:user) }
  let(:project) { create(:project) }

  describe '#call' do
    context 'when using valid params' do
      before do
        project
      end

      let(:params) { attributes_for(:message_board, project: nil) }
      it 'should create message', :aggregate_failures do
        expect { call }.to change(MessageBoard, :count).by(1)
        expect(call).to be_success
        expect(call.data).to be_a(MessageBoard)
        expect(call.response).to be_a(Hash)
      end
    end

    context 'with invalid params' do
      let(:params) { { invalid: 'not' } }
      it 'should return errors', :aggregate_failures do
        expect { call }.not_to change(MessageBoard, :count).from(0)
        expect(call).to be_failure
        expect(call.response[:error]).not_to be_empty
        expect(call.response).to be_a(Hash)
      end
    end
  end
end
