# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Invites::Update do
  subject(:call) do
    described_class.call(
      params: ActionController::Parameters.new(params).permit!,
      context: { invite: invite }
    )
  end
  let(:invite) { create(:project_user) }

  describe '#call' do
    context 'when using valid params' do
      let(:params) { { invite_status: 'rejected' } }
      it 'should update invite', :aggregate_failures do
        expect { call }.to change(invite, :invite_status).to(params[:invite_status])
        expect(call).to be_success
        expect(call.data).to be_a(ProjectUser)
        expect(call.response).to be_a(Hash)
      end
    end

    context 'with incorect attributes' do
      let(:params) { { invlid: 'nil' } }
      it 'should return errors', :aggregate_failures do
        expect { call }.not_to change(invite, :attributes)
        expect(call).to be_failure
        expect(call.data).to be_a(ProjectUser)
        expect(call.response[:error]).not_to be_empty
        expect(call.response).to be_a(Hash)
      end
    end
  end
end
