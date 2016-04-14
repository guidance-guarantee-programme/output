Given(/^I am logged in as a Pension Wise Administrator$/) do
  @administrator = create(:user, admin: true).tap(&:confirm!)

  page = UserSignInPage.new
  page.login(@administrator)
end

Given(/^there are existing Appointment Summaries$/) do
  create_list(
    :appointment_summary,
    Kaminari.config.default_per_page + 1
  )
end

When(/^I visit the Summary Browser$/) do
  @page = AppointmentSummaryBrowserPage.new
  @page.load
end

Then(/^I am presented with Appointment Summaries$/) do
  expect(@page).to have_appointments(count: Kaminari.config.default_per_page)
end

Then(/^I see there are multiple pages$/) do
  expect(@page).to have_pages
end

Then(/^the date range is displayed$/) do
  expect(@page.start_date.value).to be_present
  expect(@page.end_date.value).to be_present
end

Then(/^I am denied access$/) do
  expect(@page).to_not be_displayed
end
