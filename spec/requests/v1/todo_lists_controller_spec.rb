# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::TodoListsController, type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:todo) { create(:todo, project: project) }
  let(:todo_list) { create(:todo_list, todo: todo) }
  let(:project_user) { create(:project_user, project: project, user: user) }

  before { user }
  describe "GET #index" do
    before do
      project_user
      3.times { create(:todo_list, todo: todo) }
    end

    let(:request) { get "/v1/projects/#{project.id}/todo_lists", headers: headers }
    context 'with proper auth' do
      let(:headers) { authenticate_with_token(user) }

      it 'should return all todo lists user owns', :aggregate_failures do
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
    before do
      project_user
      todo_list
    end

    let(:request) { get "/v1/projects/#{project.id}/todo_lists/#{id}", headers: headers }

    context 'with proper auth' do
      let(:id) { todo_list.id }
      let(:headers) { authenticate_with_token(user) }

      it 'should return todo list', :aggregate_failures do
        request
        expect(response.status).to eq(200)
        expect(ActiveSupport::JSON.decode(response.body)['data']['id']).to eq("#{todo_list.id}")
      end
    end

    context 'with non existing todo list' do
      let(:id) { 'todo_list' }
      let(:headers) { authenticate_with_token(user) }

      it 'should return 404', :aggregate_failures do
        request
        expect(response.status).to eq(404)
        expect(ActiveSupport::JSON.decode(response.body)['error']).not_to be_empty
      end
    end
  end

  describe "POST #create" do
    before do
      project_user
      todo
    end

    let(:request) do
      post "/v1/projects/#{project.id}/todo_lists",
        headers: authenticate_with_token(user),
        params: { todo_list: params }
    end

    context 'with proper auth' do
      let(:params) { attributes_for(:todo_list, todo: nil) }

      it 'creates todo_list', :aggregate_failures do
        expect { request }.to change(TodoList, :count).by(1)
        expect(response.status).to eq(200)
        expect(ActiveSupport::JSON.decode(response.body)['data'].count).to eq(3)
      end
    end

    context 'with mising params' do
      let(:params) { { title: 'Title' } }

      it 'should not create todo_list', :aggregate_failures do
        request
        expect(response.status).to eq(422)
        expect(ActiveSupport::JSON.decode(response.body)['error']).not_to be_empty
      end
    end
  end

  describe "PUT #update" do
    before do
      project_user
    end

    let(:request) { put "/v1/projects/#{project.id}/todo_lists/#{id}", headers: headers, params: { todo_list: params } }

    context 'with proper auth' do
      let(:id) { todo_list.id }
      let(:headers) { authenticate_with_token(user) }
      let(:params) { { title: 'New title' } }

      it 'should update todo_list', :aggregate_failures do
        request
        expect(todo_list.reload.title).to eq(params[:title])
        expect(response.status).to eq(200)
        expect(ActiveSupport::JSON.decode(response.body)['data']['attributes']['title']).to eq(params[:title])
      end
    end

    context 'with incorrect params' do
      let(:id) { todo_list.id }
      let(:params) { { invalid: 'invalid' } }
      let(:headers) { authenticate_with_token(user) }

      it 'should return 200', :aggregate_failures do
        request
        expect(response.status).to eq(200)
        expect(ActiveSupport::JSON.decode(response.body)['data']['id']).to eq(todo_list.id.to_s)
      end
    end
  end

  describe "DELETE #delete" do
    before do
      project_user
      todo_list
    end

    let(:request) { delete "/v1/projects/#{project.id}/todo_lists/#{id}", headers: headers }

    context 'with proper auth' do
      let(:id) { todo_list.id }
      let(:headers) { authenticate_with_token(user) }

      it 'should delete todo_list', :aggregate_failures do
        expect { request }.to change(TodoList, :count).by(-1)
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
