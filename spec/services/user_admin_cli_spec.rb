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
end
