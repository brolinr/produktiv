# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Projects::Create do
  subject(:call) do
    described_class.call(
      params: ActionController::Parameters.new(params).permit!,
      context: { user: user }
    )
  end
  let(:user) { create(:user) }

  describe '#call' do
    context 'when using valid params' do
      let(:params) { attributes_for(:project, user: nil) }
      it 'should create project', :aggregate_failures do
        expect { call }.to change(Project, :count).by(1)
        expect(call).to be_success
        expect(call.data).to be_a(Project)
        expect(call.response).to be_a(Hash)
      end
    end

    context 'with missing params' do
      let(:params) { attributes_for(:project, title: nil, user: nil) }
      it 'should return errors', :aggregate_failures do
        expect { call }.not_to change(Project, :count).from(0)
        expect(call).to be_failure
        expect(call.response[:error]).not_to be_empty
        expect(call.response).to be_a(Hash)
      end
    end
  end
end
