require 'rails_helper'

RSpec.describe Invites::Create do
  subject(:call) do
    described_class.call(
      params: ActionController::Parameters.new(params).permit!,
      context: { project: project }
    )
  end
  let(:user) { create(:user) }
  let(:project) { create(:project) }

  describe '#call' do
    context 'when using valid params' do
      let(:params) { { users: [ { user_id: user.id, role: 'member' } ] } }
      it 'should create project', :aggregate_failures do
        expect { call }.to change(ProjectUser, :count).by(1)
        expect(call).to be_success
        expect(call.data).to be_a(Array)
        expect(call.response).to be_a(Hash)
      end
    end

    context 'with missing params' do
      let(:params) { { users: [ { invlid: 'attr' } ] } }
      it 'should return errors', :aggregate_failures do
        expect { call }.not_to change(ProjectUser, :count).from(0)
        expect(call).to be_failure
        expect(call.response[:error]).not_to be_empty
        expect(call.response).to be_a(Hash)
      end
    end
  end
end
