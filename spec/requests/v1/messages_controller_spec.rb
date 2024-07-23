require 'rails_helper'

RSpec.describe V1::MessagesController, type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:headers) { authenticate_with_token(project.user) }
  let(:message_board) { create(:message_board, project: project) }
  let(:project_user) { create(:project_user, project: project, user: user) }
  let(:message) { create(:message, message_board: message_board, project_user: project_user) }

  before { user }
  describe "GET #index" do
    before { message }
    let(:request) { get "/v1/projects/#{project.id}/messages", headers: headers }
    context 'with proper auth' do
      it 'should return all messages user owns', :aggregate_failures do
        request
        expect(response.status).to eq(200)
        expect(ActiveSupport::JSON.decode(response.body)['data'].count).to eq(1)
      end
    end

    context 'with improper auth' do
      let(:headers) { { invalid: 'token' } }

      it 'should return 401 and empty response', :aggregate_failures do
        request
        expect(response.status).to eq(401)
        expect(response.body).to be_empty
      end
    end
  end

  describe "GET #show" do
    before { message }
    let(:request) { get "/v1/projects/#{project.id}/messages/#{id}", headers: headers }

    context 'with proper auth' do
      let(:id) { message.id }

      it 'should return message', :aggregate_failures do
        request
        expect(response.status).to eq(200)
        expect(ActiveSupport::JSON.decode(response.body)['data']['id']).to eq("#{message.id}")
      end
    end

    context 'with non existing message' do
      let(:id) { 'user' }

      it 'should return 400', :aggregate_failures do
        request
        expect(response.status).to eq(404)
        expect(ActiveSupport::JSON.decode(response.body)['error']).not_to be_empty
      end
    end
  end

  describe "POST #create" do
  before do
    project_user
    message_board
  end
    let(:request) do
      post "/v1/projects/#{project.id}/messages",
        headers: headers, params: { message: params }
    end
    context 'with proper auth' do
      let(:params) { attributes_for(:message, project_user: nil, message_board: nil) }

      it 'creates message', :aggregate_failures do
        expect { request }.to change(Message, :count).by(1)
        expect(response.status).to eq(200)
        expect(ActiveSupport::JSON.decode(response.body)['data']['id']).to eq(Message.last.id.to_s)
      end
    end

    context 'with incorrect params' do
      let(:params) { { invalid: 'tre' } }

      it 'should not create message', :aggregate_failures do
        expect { request }.not_to change(Message, :count)
        expect(response.status).to eq(422)
        expect(ActiveSupport::JSON.decode(response.body)['error']).not_to be_empty
      end
    end
  end

  describe "PUT #update" do
    before { message }
    let(:request) { put "/v1/projects/#{project.id}/messages/#{id}", headers: headers, params: { message: params } }

    context 'with proper auth' do
      let(:id) { message.id }
      let(:params) { { title: 'board meeting' } }

      it 'should update message', :aggregate_failures do
        request
        expect(message.reload.title).to eq(params[:title])
        expect(response.status).to eq(200)
        expect(ActiveSupport::JSON.decode(response.body)['data']['attributes']['title']).to eq(params[:title])
      end
    end

    context 'with incorrect params' do
      let(:id) { message.id }
      let(:params) { { invalid: 'invalid' } }

      it 'should return 200', :aggregate_failures do
        request
        expect(response.status).to eq(200)
        expect(ActiveSupport::JSON.decode(response.body)['data']['id']).to eq(message.id.to_s)
      end
    end
  end

  describe "DELETE #delete" do
    before { message }
    let(:request) { delete "/v1/projects/#{project.id}/messages/#{id}", headers: headers }

    context 'with proper auth' do
      let(:id) { message.id }

      it 'should delete message', :aggregate_failures do
        expect { request }.to change(Message, :count).by(-1)
        expect(response.status).to eq(204)
        expect(response.body).to be_empty
      end
    end

    context 'with incorrect params' do
      let(:id) { 'nil' }

      it 'should return 200', :aggregate_failures do
        request
        expect(response.status).to eq(404)
        expect(ActiveSupport::JSON.decode(response.body)['error']).not_to be_empty
      end
    end
  end
end
