# frozen_string_literal: true
require 'rails_helper'

RSpec.describe UserAdminCli do
  let!(:admin) { create(:admin, email: 'rick@example.com') }
  let!(:team_leaders) { create(:team_leader, email: 'sanchez@example.com') }
  let!(:standard_user) { create(:user) }

  describe '#admins' do
    it 'returns the names and email addresses of current admins' do
      expect(subject.admins).to match_array(['Rick Sanchez <rick@example.com>'])
    end
  end

  describe '#team_leaders' do
    it 'returns the names and email addresses of current team leaders' do
      expect(subject.team_leaders).to match_array(['Rick Sanchez <sanchez@example.com>'])
    end
  end

  describe '#toggle_admin' do
    context 'for an existing user' do
      it 'toggles the `admin` role' do
        expect(subject.toggle_admin('rick@example.com')).not_to be_admin
        expect(subject.toggle_admin('rick@example.com')).to be_admin
      end

      context 'who already has another role' do
        it 'raises an error' do
          expect do
            expect(subject.toggle_admin('sanchez@example.com'))
          end.to raise_error(User::UnableToSetRole)
        end
      end
    end

    context 'for a non-existent user' do
      it 'returns nil' do
        expect(subject.toggle_admin('whoops@example.com')).to be_falsey
      end
    end
  end

  describe '#toggle_team_leader' do
    context 'for an existing user' do
      it 'toggles the `team_leader` role' do
        expect(subject.toggle_team_leader('sanchez@example.com')).not_to be_team_leader
        expect(subject.toggle_team_leader('sanchez@example.com')).to be_team_leader
      end

      context 'who already has another role' do
        it 'raises an error' do
          expect do
            expect(subject.toggle_team_leader('rick@example.com'))
          end.to raise_error(User::UnableToSetRole)
        end
      end
    end

    context 'for a non-existent user' do
      it 'returns nil' do
        expect(subject.toggle_admin('whoops@example.com')).to be_falsey
      end
    end
  end
end
