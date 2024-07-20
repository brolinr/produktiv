require 'rails_helper'

RSpec.describe Users::Create do
  subject(:call) { described_class.call(params: ActionController::Parameters.new(params).permit!) }

  describe '#call' do
    context 'when using valid params' do
      let(:params) { attributes_for(:user) }
      it 'should create user', :aggregate_failures do
        expect { call }.to change(User, :count).by(1)
        expect(call).to be_success
        expect(call.data).to be_a(User)
        expect(call.response).to be_a(Hash)
      end
    end

    context 'with missing params' do
      let(:params) { attributes_for(:user, name: nil) }

      it 'should return errors', :aggregate_failures do
        expect { call }.not_to change(User, :count).from(0)
        expect(call).to be_failure
        expect(call.response[:error]).not_to be_empty
        expect(call.response).to be_a(Hash)
      end
    end

    context 'with incorect attributes' do
      let(:params) { { invlid: nil } }

      it 'should return errors', :aggregate_failures do
        expect { call }.not_to change(User, :count).from(0)
        expect(call).to be_failure
        expect(call.response[:error]).not_to be_empty
        expect(call.response).to be_a(Hash)
      end
    end
  end
end
