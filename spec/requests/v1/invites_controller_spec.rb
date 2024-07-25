# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::InvitesController, type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:invite) { create(:project_user, user: user, project: project) }

  before { user }
  describe "GET #index" do
    before { invite }
    let(:request) { get "/v1/projects/#{project.id}/invites", headers: headers }
    context 'with proper auth' do
      let(:headers) { authenticate_with_token(user) }

      it 'should return all invites user owns', :aggregate_failures do
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
    before { invite }
    let(:request) { get "/v1/invites/#{id}", headers: headers }

    context 'with proper auth' do
      let(:id) { invite.id }
      let(:headers) { authenticate_with_token(user) }

      it 'should return invite', :aggregate_failures do
        request
        expect(response.status).to eq(200)
        expect(ActiveSupport::JSON.decode(response.body)['data']['id']).to eq("#{invite.id}")
      end
    end

    context 'with non existing invite' do
      let(:id) { 'user' }
      let(:headers) { authenticate_with_token(user) }

      it 'should return 400', :aggregate_failures do
        request
        expect(response.status).to eq(404)
        expect(ActiveSupport::JSON.decode(response.body)['error']).not_to be_empty
      end
    end
  end

  describe "POST #create" do
    let(:request) do
      post "/v1/projects/#{project.id}/invites",
        headers: authenticate_with_token(user),
        params: { invites: { users: params } }
    end
    context 'with proper auth' do
      let(:params) { [ { user_id: user.id, role: 'member' } ] }

      it 'creates invite', :aggregate_failures do
        expect { request }.to change(ProjectUser, :count).by(1)
        expect(response.status).to eq(200)
        expect(ActiveSupport::JSON.decode(response.body)['data'].count).to eq(1)
      end
    end

    context 'with incorrect params' do
      let(:params) { [ { invalid: 'tre' } ] }

      it 'should not create invite', :aggregate_failures do
        expect { request }.not_to change(ProjectUser, :count)
        expect(response.status).to eq(422)
        expect(ActiveSupport::JSON.decode(response.body)['error']).not_to be_empty
      end
    end
  end

  describe "PUT #update" do
    before { invite }
    let(:request) { put "/v1/invites/#{id}", headers: headers, params: { invite: params } }

    context 'with proper auth' do
      let(:id) { invite.id }
      let(:headers) { authenticate_with_token(user) }
      let(:params) { { role: 'admin' } }

      it 'should update invite', :aggregate_failures do
        request
        expect(invite.reload.role).to eq(params[:role])
        expect(response.status).to eq(200)
        expect(ActiveSupport::JSON.decode(response.body)['data']['attributes']['role']).to eq(params[:role])
      end
    end

    context 'with incorrect params' do
      let(:id) { invite.id }
      let(:params) { { invalid: 'invalid' } }
      let(:headers) { authenticate_with_token(user) }

      it 'should return 200', :aggregate_failures do
        request
        expect(response.status).to eq(200)
        expect(ActiveSupport::JSON.decode(response.body)['data']['id']).to eq(invite.id.to_s)
      end
    end
  end

  describe "DELETE #delete" do
    before { invite }
    let(:request) { delete "/v1/invites/#{id}", headers: headers }

    context 'with proper auth' do
      let(:id) { invite.id }
      let(:headers) { authenticate_with_token(user) }

      it 'should delete invite', :aggregate_failures do
        expect { request }.to change(ProjectUser, :count).by(-1)
        expect(response.status).to eq(204)
        expect(response.body).to be_empty
      end
    end

    context 'with incorrect params' do
      let(:id) { 'nil' }
      let(:headers) { authenticate_with_token(user) }

      it 'should return 200', :aggregate_failures do
        request
        expect(response.status).to eq(404)
        expect(ActiveSupport::JSON.decode(response.body)['error']).not_to be_empty
      end
    end
  end
end
