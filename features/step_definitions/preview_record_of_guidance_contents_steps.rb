When(/^I preview (?:their|a) record of guidance$/) do
  page = AppointmentSummaryPage.new
  page.load
  page.fill_in(@appointment_summary)
  page.submit.click
end

Then(/^the sections that the preview includes should be \(in order\):$/) do |table|
  sections = table.raw.flatten
  expect(page).to include_output_document_sections(sections)
end

Then(/^the preview should include the "(.*?)" version of the "pension pot" section$/) do |version|
  version = case version
            when 'only their DC pot and state pension' then 'pension'
            when 'multiple sources'                    then 'other'
            end

  expect(page).to include_output_document_section('pension pot').at_version(version)
end

Then(/^the record of guidance preview should include their details$/) do
  output_document = OutputDocument.new(@appointment_summary)

  expect(page).to have_content(output_document.attendee_name)
  expect(page).to have_content(output_document.value_of_pension_pots)
end

Then(/^the record of guidance preview should include the details of the appointment$/) do
  output_document = OutputDocument.new(@appointment_summary)

  expect(page).to have_content(output_document.appointment_date)
  expect(page).to have_content(output_document.guider_first_name)
  expect(page).to have_content(output_document.guider_organisation)
end
