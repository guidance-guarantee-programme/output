# frozen_string_literal: true
Given(/^a guider has submitted the customer's details in an appointment summary$/) do
  @appointment_summary = fixture(:populated_appointment_summary)
  @email = @appointment_summary.email
  page = AppointmentSummaryPage.new
  page.load
  page.fill_in(@appointment_summary)
  page.submit.click
end

When(/^they confirm the email address is correctly entered$/) do
  email_confirmation_page = EmailConfirmationPage.new
  email_confirmation_page.confirm.click
end

Then(/^they confirm the preview of the appointment$/) do
  preview_page = PreviewPage.new
  preview_page.confirm.click
end

Then(/^the confirmed email address is saved$/) do
  expect(AppointmentSummary.last.email).to eq(@email)
end

When(/^they correct the email address during the confirmation step$/) do
  @email = 'updated@email.com'
  email_confirmation_page = EmailConfirmationPage.new
  email_confirmation_page.email.set @email
  email_confirmation_page.confirm.click
end
