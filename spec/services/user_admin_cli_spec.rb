# frozen_string_literal: true
require 'rails_helper'

RSpec.describe UserAdminCli do
  let!(:admin) { create(:admin, email: 'rick@example.com') }
  let!(:standard_user) { create(:user) }

  describe '#admins' do
    it 'returns the names and email addresses of current admins' do
      expect(subject.admins).to match_array(['Rick Sanchez <rick@example.com>'])
    end
  end

  describe '#toggle' do
    context 'for an existing user' do
      it 'toggles the `admin` flag' do
        expect(subject.toggle('rick@example.com')).not_to be_admin
        expect(subject.toggle('rick@example.com')).to be_admin
      end
    end

    context 'for a non-existent user' do
      it 'returns nil' do
        expect(subject.toggle('whoops@example.com')).to be_falsey
      end
    end
  end
end
