When(/^someone visits the output application$/) do
  appointment_summary_page = AppointmentSummaryPage.new
  appointment_summary_page.load
end

Then(/^they are presented with a login page$/) do
  sign_in_page = UserSignInPage.new
  expect(sign_in_page).to be_displayed
end
