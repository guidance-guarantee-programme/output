# frozen_string_literal: true
require 'rails_helper'

RSpec.describe AppointmentSummariesController, 'GET #new', type: :controller do
  let(:email) { 'guider@example.com' }
  let(:password) { 'pensionwise' }
  let(:user) do
    User.create(email: email, password: password).tap(&:confirm!)
  end

  subject { response }

  context 'when not authenticated' do
    before do
      get :new
    end

    it { is_expected.to redirect_to(controller: 'devise/sessions', action: :new) }
  end

  context 'when authenticated' do
    before do
      sign_in user
      get :new
    end

    it { is_expected.to be_ok }
  end
end
