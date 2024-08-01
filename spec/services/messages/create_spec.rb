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
  let(:chat) { create(:chat, project: project) }
  let(:chat_member) { create(:chat_member, chat: chat, project_user: project_user) }

  describe '#call' do
    context 'when using valid for messageboard params' do
      before do
        project_user
        message_board
      end

      let(:params) do
        attributes_for(:message, room: nil, sender: nil, sender_type: 'ProjectUser', room_type: 'MessageBoard')
      end
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

    context 'with valid params for chat' do
      before do
        project_user
        chat
        chat_member
      end

      let(:params) do
        attributes_for(
          :message,
          room: nil,
          sender: nil,
          sender_id: chat_member.id,
          sender_type: 'ChatMember',
          room_type: 'Chat',
          room_id: chat.id
        )
      end

      it 'should create message', :aggregate_failures do
        expect { call }.to change(Message, :count).by(1)
        expect(call).to be_success
        expect(call.data).to be_a(Message)
        expect(call.response).to be_a(Hash)
      end
    end
  end
end
