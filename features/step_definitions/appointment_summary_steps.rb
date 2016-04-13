Given(/^I am logged in as a Pension Wise Administrator$/) do
  @administrator = Administrator.create!
  login_as @administrator
end

When(/^I visit the Summary Browser$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I am presented with a table of Appointment Summaries$/) do
  pending # express the regexp above with the code you wish you had
end
