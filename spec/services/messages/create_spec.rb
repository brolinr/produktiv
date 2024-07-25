# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Messages::Create do
  subject(:call) do
    described_class.call(
      params: ActionController::Parameters.new(params).permit!,
      context: { user: user, project: project }
    )
  end
  let(:user) { create(:user) }
  let(:project) { create(:project) }
  let(:project_user) { create(:project_user, user: user, project: project, invite_status: 'accepted') }
  let(:message_board) { create(:message_board, project: project) }

  describe '#call' do
    context 'when using valid params' do
      before do
        project_user
        message_board
      end

      let(:params) { attributes_for(:message, room: nil, project_user: nil) }
      it 'should create message', :aggregate_failures do
        expect { call }.to change(Message, :count).by(1)
        expect(call).to be_success
        expect(call.data).to be_a(Message)
        expect(call.response).to be_a(Hash)
      end
    end

    context 'with missing params' do
      let(:params) { attributes_for(:message, room: nil, project_user: nil, title: nil) }
      it 'should return errors', :aggregate_failures do
        expect { call }.not_to change(Message, :count).from(0)
        expect(call).to be_failure
        expect(call.response[:error]).not_to be_empty
        expect(call.response).to be_a(Hash)
      end
    end
  end
end
