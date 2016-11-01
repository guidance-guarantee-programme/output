# frozen_string_literal: true
Before('~@unauthenticated') do
  email = 'guider@example.com'
  create(:user, email: email)
end
