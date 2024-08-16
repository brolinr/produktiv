# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::EventsController, type: :request do
  let(:user_1) { create(:user) }
  let(:user_2) { create(:user) }
  let(:user) { create(:user) }

  let(:project) { create(:project, user: user) }
  let(:event_scheduler) { create(:event_scheduler, project: project) }
  let(:project_user_1) { create(:project_user, project: project, user: user_1, invite_status: 'accepted') }
  let(:project_user_2) { create(:project_user, project: project, user: user_2, invite_status: 'accepted') }
  let(:project_user) { create(:project_user, project: project, user: user, invite_status: 'accepted') }
  let(:event) { create(:event, event_scheduler: event_scheduler, project_user: project_user) }

  before do
    event_scheduler
    project_user
    project_user_1
    project_user_2
  end

  describe "GET #index" do
    before do
      3.times { create(:event, event_scheduler: event_scheduler, project_user: project_user) }
    end

    let(:request) { get "/v1/projects/#{project.id}/events", headers: headers }

    context 'with proper auth' do
      let(:headers) { authenticate_with_token(user) }

      it 'should return all events user owns', :aggregate_failures do
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
    before { event }

    let(:request) { get "/v1/projects/#{project.id}/events/#{id}", headers: headers }

    context 'with proper auth' do
      let(:id) { event.id }
      let(:headers) { authenticate_with_token(user) }

      it 'should return event', :aggregate_failures do
        request
        expect(response.status).to eq(200)
        expect(ActiveSupport::JSON.decode(response.body)['data']['id']).to eq("#{event.id}")
      end
    end

    context 'with non existing event' do
      let(:id) { 'event' }
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
      event_scheduler
    end

    let(:request) do
      post "/v1/projects/#{project.id}/events",
        headers: authenticate_with_token(user),
        params: { event: params }
    end

    context 'with proper auth' do
      let(:params) { attributes_for(:event) }

      it 'creates todo_list', :aggregate_failures do
        expect { request }.to change(event_scheduler.events, :count).by(1)
        expect(response.status).to eq(200)
        expect(ActiveSupport::JSON.decode(response.body)['data'].count).to eq(3)
      end
    end

    context 'with mising params' do
      let(:params) { { invalid: 'Title' } }

      it 'should not create todo_list', :aggregate_failures do
        expect { request }.not_to change(event_scheduler.events, :count).from(0)
        expect(response.status).to eq(422)
        expect(ActiveSupport::JSON.decode(response.body)['error']).not_to be_empty
      end
    end

    context 'with participants attached' do
      let(:project_user_1) { create(:project_user, project: project) }
      let(:project_user_2) { create(:project_user, project: project) }
      let(:params) { attributes_for(:event, project_user_ids: [ project_user_1.id, project_user_2.id ]) }

      it 'creates todo_list', :aggregate_failures do
        expect { request }.to change(event_scheduler.events, :count).by(1)
        expect(EventParticipant.all.pluck(:project_user_id)).to match([ project_user_1.id, project_user_2.id ])
        expect(response.status).to eq(200)
        expect(ActiveSupport::JSON.decode(response.body)['data'].count).to eq(3)
      end
    end
  end

  describe "PUT #update" do
    before do
      event
    end

    let(:request) do
      put "/v1/projects/#{project.id}/events/#{id}",
        headers: headers, params: { event: params }
    end

    context 'with proper auth' do
      let(:id) { event.id }
      let(:headers) { authenticate_with_token(user) }
      let(:params) { { title: 'New title' } }

      it 'should update event', :aggregate_failures do
        request
        expect(event.reload.title).to eq(params[:title])
        expect(response.status).to eq(200)
        expect(ActiveSupport::JSON.decode(response.body)['data']['attributes']['title']).to eq(params[:title])
      end
    end

    context 'with unpermitted params' do
      let(:id) { event.id }
      let(:params) { { invalid: 'invalid' } }
      let(:headers) { authenticate_with_token(user) }

      it 'should return 200', :aggregate_failures do
        request
        expect(response.status).to eq(200)
        expect(ActiveSupport::JSON.decode(response.body)['data']['id']).to eq(event.id.to_s)
      end
    end

    context 'with params for altering event_participantss' do
      before do
        [ project_user_1, project_user_2 ].each do |project_user|
          create(:event_participant, event: event, project_user: project_user)
        end
      end

      let(:id) { event.id }
      let(:params) { { project_user_ids: [ project_user.id ] } }
      let(:headers) { authenticate_with_token(user) }

      it 'should return 200', :aggregate_failures do
        expect { request }.to change(event.event_participants, :count).from(2).to(1)
        expect(response.status).to eq(200)
        expect(ActiveSupport::JSON.decode(response.body)['data']['id']).to eq(event.id.to_s)
      end
    end
  end

  describe "DELETE #delete" do
    before do
      event
    end

    let(:request) { delete "/v1/projects/#{project.id}/events/#{id}", headers: headers }

    context 'with proper auth' do
      let(:id) { event.id }
      let(:headers) { authenticate_with_token(user) }

      it 'should delete event', :aggregate_failures do
        expect { request }.to change(Event, :count).by(-1)
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
