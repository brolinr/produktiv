# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::ProjectsController, type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }

  before { user }
  describe "GET #index" do
    before { 3.times { create(:project, user: user) } }
    let(:request) { get '/v1/projects', headers: headers }
    context 'with proper auth' do
      let(:headers) { authenticate_with_token(user) }

      it 'should return all projects user owns', :aggregate_failures do
        request
        expect(response.status).to eq(200)
        expect(ActiveSupport::JSON.decode(response.body)['data'].count).to eq(3)
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
    before { project }
    let(:request) { get "/v1/projects/#{id}", headers: headers }

    context 'with proper auth' do
      let(:id) { project.id }
      let(:headers) { authenticate_with_token(user) }

      it 'should return project', :aggregate_failures do
        request
        expect(response.status).to eq(200)
        expect(ActiveSupport::JSON.decode(response.body)['data']['id']).to eq("#{project.id}")
      end
    end

    context 'with non existing project' do
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
      post '/v1/projects',
        headers: authenticate_with_token(user),
        params: { project: params }
    end
    context 'with proper auth' do
      let(:params) { attributes_for(:project, user: nil) }

      it 'creates project', :aggregate_failures do
        expect { request }.to change(Project, :count).by(1)
        expect(response.status).to eq(200)
        expect(ActiveSupport::JSON.decode(response.body)['data'].count).to eq(3)
      end
    end

    context 'with mising params' do
      let(:params) { { title: 'Title' } }

      it 'should not create project', :aggregate_failures do
        request
        expect(response.status).to eq(422)
        expect(ActiveSupport::JSON.decode(response.body)['error']).not_to be_empty
      end
    end
  end

  describe "PUT #update" do
    before { project }
    let(:request) { put "/v1/projects/#{id}", headers: headers, params: { project: params } }

    context 'with proper auth' do
      let(:id) { project.id }
      let(:headers) { authenticate_with_token(user) }
      let(:params) { { title: 'New title' } }

      it 'should update project', :aggregate_failures do
        request
        expect(project.reload.title).to eq(params[:title])
        expect(response.status).to eq(200)
        expect(ActiveSupport::JSON.decode(response.body)['data']['attributes']['title']).to eq(params[:title])
      end
    end

    context 'with incorrect params' do
      let(:id) { project.id }
      let(:params) { { invalid: 'invalid' } }
      let(:headers) { authenticate_with_token(user) }

      it 'should return 200', :aggregate_failures do
        request
        expect(response.status).to eq(200)
        expect(ActiveSupport::JSON.decode(response.body)['data']['id']).to eq(project.id.to_s)
      end
    end
  end

  describe "DELETE #delete" do
    before { project }
    let(:request) { delete "/v1/projects/#{id}", headers: headers }

    context 'with proper auth' do
      let(:id) { project.id }
      let(:headers) { authenticate_with_token(user) }

      it 'should delete project', :aggregate_failures do
        expect { request }.to change(Project, :count).by(-1)
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
