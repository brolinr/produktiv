require 'rails_helper'

RSpec.describe MessageBoards::Update do
  subject(:call) do
    described_class.call(
      params: ActionController::Parameters.new(params).permit!,
      context: { message_board: message_board }
    )
  end
  let(:message_board) { create(:message_board) }

  describe '#call' do
    context 'when using valid params' do
      let(:params) { { title: 'New TItle' } }
      it 'should update message_board', :aggregate_failures do
        expect { call }.to change(message_board, :title).to(params[:title])
        expect(call).to be_success
        expect(call.data).to be_a(MessageBoard)
        expect(call.response).to be_a(Hash)
      end
    end

    context 'with incorect attributes' do
      let(:params) { { invlid: nil } }
      it 'should return errors', :aggregate_failures do
        expect { call }.not_to change(message_board, :attributes)
        expect(call).to be_failure
        expect(call.response[:error]).not_to be_empty
        expect(call.response).to be_a(Hash)
      end
    end
  end
end
