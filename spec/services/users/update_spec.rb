# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::Update do
  subject(:call) do
    described_class.call(
      params: ActionController::Parameters.new(params).permit!,
      context: { user: user }
    )
  end
  let(:user) { create(:user) }

  describe '#call' do
    context 'when using valid params' do
      let(:params) { { name: 'New Name' } }
      it 'should update user', :aggregate_failures do
        expect { call }.to change(user, :name).to(params[:name])
        expect(call).to be_success
        expect(call.data).to be_a(User)
        expect(call.response).to be_a(Hash)
      end
    end

    context 'with incorect attributes' do
      let(:params) { { invlid: nil } }
      it 'should return errors', :aggregate_failures do
        expect { call }.not_to change(user, :attributes)
        expect(call).to be_failure
        expect(call.response[:error]).not_to be_empty
        expect(call.response).to be_a(Hash)
      end
    end
  end
end
