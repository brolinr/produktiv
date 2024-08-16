# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Events::Update do
  subject(:call) do
    described_class.call(
      params: ActionController::Parameters.new(params).permit!,
      context: { event: event }
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
  let(:event) { create(:event, event_scheduler: event_scheduler, project_user: project_user) }

  let(:event_participants) do
    [ project_user, project_user_1, project_user_2 ].each do |project_user|
      create(:event_participant, project_user: project_user, event: event)
    end
  end

  before do
    event_participants
  end

  context 'with valid params' do
    let(:params) { { project_user_ids: [ project_user.id, project_user_1.id ], description: 'New description' } }

    it 'updates event and participants', :aggregate_failures do
      expect { call }.to change(EventParticipant, :count).by(-1)
      expect(event.reload.description.to_plain_text).to eq(params[:description])
      expect(call).to be_success
      expect(call.data).to be_a(Event)
      expect(call.response).to be_a(Hash)
    end
  end

  context 'with incorect attributes' do
    let(:params) { { invlid: nil } }
    it 'should return errors', :aggregate_failures do
      expect { call }.not_to change(event, :attributes)
      expect(call).to be_failure
      expect(call.response[:error]).not_to be_empty
      expect(call.response).to be_a(Hash)
    end
  end
end
