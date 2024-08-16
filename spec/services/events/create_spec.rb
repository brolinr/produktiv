# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Events::Create do
  subject(:call) do
    described_class.call(
      params: ActionController::Parameters.new(params).permit!,
      context: { user: user, project: project }
    )
  end

  let(:user_1) { create(:user) }
  let(:user_2) { create(:user) }
  let(:user) { create(:user) }

  let(:project) { create(:project, user: user) }
  let(:event_scheduler) { create(:event_scheduler, project: project) }
  let(:project_user_1) { create(:project_user, project: project, user: user_1, invite_status: 'accepted') }
  let(:project_user_2) { create(:project_user, project: project, user: user_2, invite_status: 'accepted') }
  let(:project_user) { create(:project_user, project: project, user: user, invite_status: 'accepted') }

  # let(:project_user) do
  #   [user_1, user_2].each do |u|
  #     create(:project_user, project: project, user: u)
  #   end
  # end

  before do
    event_scheduler
    project_user
    project_user_1
    project_user_2
  end

  context 'with valid params' do
    context 'without intent to create participants' do
      let(:params) { attributes_for(:event, event_scheduler: nil, project_user: nil) }

      it 'creates event successfully', :aggregate_failures do
        expect { call }.to change(Event, :count).by(1)
        expect(call).to be_success
        expect(call.data).to be_a(Event)
        expect(call.response).to be_a(Hash)
      end
    end

    context 'with intent to create participants' do
      let(:params) do
        attributes_for(
          :event,
          event_scheduler: nil,
          project_user: nil,
          project_user_ids: [ project_user_1.id, project_user_2.id ]
        )
      end

      it 'creates event and participants successfully', :aggregate_failures do
        expect { call }.to change(Event, :count).by(1).and(change(EventParticipant, :count).by(2))
        expect(call).to be_success
        expect(call.data).to be_a(Event)
        expect(call.response).to be_a(Hash)
      end
    end
  end

  context 'with invalid params' do
    let(:params) { { invalid: 'nilos' } }

    it 'creates event and participants successfully', :aggregate_failures do
      expect { call }.not_to change(Message, :count).from(0)
      expect(call).to be_failure
      expect(call.response[:error]).not_to be_empty
      expect(call.response).to be_a(Hash)
    end
  end
end
