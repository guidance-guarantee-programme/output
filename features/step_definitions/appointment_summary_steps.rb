# frozen_string_literal: true
Given(/^I am logged in as a Pension Wise Administrator$/) do
  create(:user, permissions: ['analyst'])
end
