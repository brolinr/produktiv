# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::Projects::ChatsController, type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:project_user) { create(:project_user, project: project, user: user, invite_status: 'accepted') }
  let(:chat) { create(:chat, project: project) }
  let(:chat_member) { create(:chat_member, chat: chat, project_user: project_user) }
  let(:header) { authenticate_with_token(user) }

  before { project_user }

  describe "GET #index" do
    before { chat_member }
    let(:request) { get "/v1/projects/#{project.id}/chats", headers: header }

    it 'returns all chats within project', :aggregate_failures do
      request
      expect(response.status).to eq(302)
      expect(ActiveSupport::JSON.decode(response.body)['data'].count).to eq(1)
    end
  end

  describe "get #show" do
    before { chat_member }
    let(:request) { get "/v1/projects/#{project.id}/chats/#{id}", headers: header }

    context 'with existing chat' do
      let(:id) { chat.id }
      it 'returns user chat', :aggregate_failures do
        request
        expect(response.status).to eq(302)
        expect(ActiveSupport::JSON.decode(response.body)['data']['id']).to eq("#{chat.id}")
      end
    end

    context 'with non existing invite' do
      let(:id) { 'chat' }

      it 'should return 404', :aggregate_failures do
        request
        expect(response.status).to eq(404)
        expect(ActiveSupport::JSON.decode(response.body)['error']).not_to be_empty
      end
    end
  end

  describe "POST #create" do
    let(:request) { post "/v1/projects/#{project.id}/chats/", headers: header, params: params }

    context 'with permitted params' do
      let(:params) { { chat: { project_users: [ project_user.id ] } } }

      it 'creates chat and chat members', :aggregate_failures do
        expect { request }.to change(Chat, :count).by(1).and change(ChatMember, :count).by(1)
        expect(response.status).to eq(200)
        expect(response.body)
        expect(ActiveSupport::JSON.decode(response.body)['data']['id']).to eq(Chat.last.id.to_s)
      end
    end

    context 'with unpermitted params' do
      let(:params) { { chat: { project_users: [ 'nvalid', 'worse' ] } } }

      it 'creates chat and chat members', :aggregate_failures do
        expect { request }.not_to change(Chat, :count)
        expect(ChatMember.count).to eq(0)
        expect(response.status).to eq(422)
        expect(response.body)
        expect(ActiveSupport::JSON.decode(response.body)['error']).not_to be_empty
      end
    end
  end

  describe "DELETE #delete" do
    before { chat_member }
    let(:request) { delete "/v1/projects/#{project_id}/chats/#{id}", headers: header }

    context 'with proper auth' do
      let(:id) { chat.id }
      let(:project_id) { project.id }

      it 'should delete message', :aggregate_failures do
        expect { request }.to change(Chat, :count).by(-1)
        expect(response.status).to eq(204)
        expect(response.body).to be_empty
      end
    end

    context 'with incorrect params' do
      let(:project_id) { 'nilos' }
      let(:id) { 'nil' }

      it 'should return 404', :aggregate_failures do
        request
        expect(response.status).to eq(404)
        expect(ActiveSupport::JSON.decode(response.body)['error']).not_to be_empty
      end
    end
  end
end
