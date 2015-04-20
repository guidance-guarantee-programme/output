Given(/^the customer prefers to receive documentation in (.*?) format$/) do |format_preference|
  @appointment_summary = fixture(:populated_appointment_summary).tap do |as|
    as.format_preference = format_preference.gsub(/\s+/, '_')
  end
end

When(/^we send them documentation$/) do
  step('we send them their record of guidance')
end

Then(/^it should be in (.*?) format$/) do |format_preference|
  expect_uploaded_csv_to_include(format: format_preference.gsub(/\s+/, '_'))
end

Then(/^we should not send them any documentation, for now$/) do
  step('we send them their record of guidance')

  expect(read_uploaded_csv).to be_empty
end
