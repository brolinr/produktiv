# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::Projects::TodoItemsController, type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:todo) { create(:todo, project: project) }
  let(:todo_list) { create(:todo_list, todo: todo) }
  let(:project_user) { create(:project_user, project: project, user: user, invite_status: 'accepted') }
  let(:todo_item) { create(:todo_item, todo_list: todo_list, project_user: project_user) }

  before { user }
  describe "GET #index" do
    before do
      3.times { create(:todo_item, project_user: project_user, todo_list: todo_list) }
    end

    let(:request) { get "/v1/projects/#{project.id}/todo_lists/#{todo_list.id}/todo_items", headers: headers }
    context 'with proper auth' do
      let(:headers) { authenticate_with_token(user) }

      it 'should return all todo items user owns', :aggregate_failures do
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
    before { todo_item }

    let(:request) { get "/v1/projects/#{project.id}/todo_lists/#{todo_list.id}/todo_items/#{id}", headers: headers }

    context 'with proper auth' do
      let(:id) { todo_item.id }
      let(:headers) { authenticate_with_token(user) }

      it 'should return todo item', :aggregate_failures do
        request
        expect(response.status).to eq(200)
        expect(ActiveSupport::JSON.decode(response.body)['data']['id']).to eq("#{todo_item.id}")
      end
    end

    context 'with non existing todo item' do
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
      todo_list
    end

    let(:request) do
      post "/v1/projects/#{project.id}/todo_lists/#{todo_list.id}/todo_items",
        headers: authenticate_with_token(user),
        params: { todo_item: params }
    end

    context 'with proper auth' do
      let(:params) { attributes_for(:todo_item) }

      it 'creates todo_list', :aggregate_failures do
        expect { request }.to change(todo_list.todo_items, :count).by(1)
        expect(response.status).to eq(200)
        expect(ActiveSupport::JSON.decode(response.body)['data'].count).to eq(3)
      end
    end

    context 'with mising params' do
      let(:params) { { invalid: 'Title' } }

      it 'should not create todo_list', :aggregate_failures do
        request
        expect(response.status).to eq(422)
        expect(ActiveSupport::JSON.decode(response.body)['error']).not_to be_empty
      end
    end

    context 'with assignees attached' do
      let(:project_user_1) { create(:project_user, project: project) }
      let(:project_user_2) { create(:project_user, project: project) }
      let(:params) { attributes_for(:todo_item, project_user_ids: [ project_user_1.id, project_user_2.id ]) }

      it 'creates todo_list', :aggregate_failures do
        expect { request }.to change(todo_list.todo_items, :count).by(1)
        expect(Assignee.all.pluck(:project_user_id)).to match([ project_user_1.id, project_user_2.id ])
        expect(response.status).to eq(200)
        expect(ActiveSupport::JSON.decode(response.body)['data'].count).to eq(3)
      end
    end
  end

  describe "PUT #update" do
    before do
      project_user
    end

    let(:request) do
      put "/v1/projects/#{project.id}/todo_lists/#{todo_list.id}/todo_items/#{id}",
        headers: headers, params: { todo_item: params }
    end

    context 'with proper auth' do
      let(:id) { todo_item.id }
      let(:headers) { authenticate_with_token(user) }
      let(:params) { { title: 'New title' } }

      it 'should update todo_item', :aggregate_failures do
        request
        expect(todo_item.reload.title).to eq(params[:title])
        expect(response.status).to eq(200)
        expect(ActiveSupport::JSON.decode(response.body)['data']['attributes']['title']).to eq(params[:title])
      end
    end

    context 'with unpermitted params' do
      let(:id) { todo_item.id }
      let(:params) { { invalid: 'invalid' } }
      let(:headers) { authenticate_with_token(user) }

      it 'should return 200', :aggregate_failures do
        request
        expect(response.status).to eq(200)
        expect(ActiveSupport::JSON.decode(response.body)['data']['id']).to eq(todo_item.id.to_s)
      end
    end

    context 'with params for altering assigneess' do
      before do
        project_user_1 = create(:project_user, project: project)
        project_user_2 = create(:project_user, project: project)
        [ project_user_1, project_user_2 ].each do |project_user|
          create(:assignee, task: todo_item, project_user: project_user)
        end
      end

      let(:id) { todo_item.id }
      let(:params) { { project_user_ids: [ project_user.id ] } }
      let(:headers) { authenticate_with_token(user) }

      it 'should return 200', :aggregate_failures do
        expect { request }.to change(todo_item.assignees, :count).from(2).to(1)
        expect(response.status).to eq(200)
        expect(ActiveSupport::JSON.decode(response.body)['data']['id']).to eq(todo_item.id.to_s)
      end
    end
  end

  describe "DELETE #delete" do
    before do
      project_user
      todo_item
    end

    let(:request) { delete "/v1/projects/#{project.id}/todo_lists/#{todo_list.id}/todo_items/#{id}", headers: headers }

    context 'with proper auth' do
      let(:id) { todo_item.id }
      let(:headers) { authenticate_with_token(user) }

      it 'should delete todo_item', :aggregate_failures do
        expect { request }.to change(TodoItem, :count).by(-1)
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
