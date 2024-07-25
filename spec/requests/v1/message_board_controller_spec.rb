# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::MessageBoardController, type: :request do
  let(:project) { create(:project) }
  let(:message_board) { create(:message_board, project: project) }
  let(:headers) { authenticate_with_token(project.user) }

  describe "GET /show" do
    before { message_board }
    let(:request) { get "/v1/projects/#{project_id}/message_board", headers: headers }

    context 'with valid project id' do
      let(:project_id) { project.id }

      it 'returns message board', :aggregate_failures do
        request
        expect(response.status).to eq(302)
        expect(ActiveSupport::JSON.decode(response.body)['data']['id']).to eq("#{message_board.id}")
      end
    end

    context 'with invalid project id' do
      let(:project_id) { 'not_in_plan' }

      it 'returns errors', :aggregate_failures do
        request
        expect(response.status).to eq(404)
        expect(ActiveSupport::JSON.decode(response.body)['error']).not_to be_empty
      end
    end
  end

  describe "PATCH /update" do
    before { message_board }
    let(:request) do
 patch "/v1/projects/#{project_id}/message_board", headers: headers, params: { message_board: params } end

    context 'with proper auth' do
      let(:project_id) { project.id }
      let(:params) { { title: 'Staff board' } }

      it 'should update message_board', :aggregate_failures do
        request
        expect(message_board.reload.title).to eq(params[:title])
        expect(response.status).to eq(200)
        expect(ActiveSupport::JSON.decode(response.body)['data']['attributes']['title']).to eq(params[:title])
      end
    end

    context 'with invalid project id params' do
      let(:project_id) { 'nil' }
      let(:params) { { invalid: 'invalid' } }

      it 'should return 250000', :aggregate_failures do
        request
        expect(response.status).to eq(404)
        expect(ActiveSupport::JSON.decode(response.body)['error']).not_to be_empty
      end
    end
  end
end
