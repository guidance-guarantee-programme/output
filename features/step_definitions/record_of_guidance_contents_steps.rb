When(/^we send (?:them their|a) record of guidance$/) do
  appointment_summary_page = AppointmentSummaryPage.new
  appointment_summary_page.load
  appointment_summary_page.fill_in(@appointment_summary)
  appointment_summary_page.submit.click

  preview_page = PreviewPage.new
  preview_page.confirm.click

  ProcessOutputDocuments.new.call
end

Given(/^the customer has access to income during retirement from (.*?)$/) do |sources_of_income|
  @appointment_summary = fixture(:populated_appointment_summary).tap do |as|
    as.income_in_retirement = case sources_of_income
                              when 'only their DC pot and state pension' then 'pension'
                              when 'multiple sources'                    then 'other'
                              end
  end
end

Then(/^the "pension pot" section should be the "(.*?)" version$/) do |version|
  version = case version
            when 'only their DC pot and state pension' then 'pension'
            when 'multiple sources'                    then 'other'
            end

  expect_uploaded_csv_to_include(income_in_retirement: version)
end

Given(/^(?:I|we) have captured the customer's details in an appointment summary$/) do
  @appointment_summary = fixture(:populated_appointment_summary)
end

Then(/^the record of guidance should include their details$/) do
  expected = fixture(:populated_csv).slice(:attendee_name)

  expect_uploaded_csv_to_include(expected)
end

Given(/^(?:I|we) have captured appointment details in an appointment summary$/) do
  @appointment_summary = fixture(:populated_appointment_summary)
end

Then(/^the record of guidance should include the details of the appointment$/) do
  expected = fixture(:populated_csv).slice(%i(appointment_date guider_first_name guider_organisation))

  expect_uploaded_csv_to_include(expected)

  appointment_reference = read_uploaded_csv.first[:appointment_reference]
  expected_reference = %r{^\d+/#{@appointment_summary.reference_number}$}

  expect(appointment_reference).to match(expected_reference)
end
