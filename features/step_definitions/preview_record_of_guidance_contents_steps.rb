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

Then(/^the record of guidance preview should include their details$/) do
  output_document = OutputDocument.new(@appointment_summary)

  expect(page).to have_content(output_document.attendee_name)
end

Then(/^the record of guidance preview should include the details of the appointment$/) do
  output_document = OutputDocument.new(@appointment_summary)

  expect(page).to have_content(output_document.appointment_date)
  expect(page).to have_content(output_document.guider_first_name)
  expect(page).to have_content(output_document.guider_organisation)
end

Then(/^the record of guidance preview should include supplementary information about "(.*?)"$/) do |topic|
  section = case topic
            when 'Benefits and pension income' then
              'benefits'
            when 'Debt and pensions' then
              'debt'
            when 'Pensions and ill health' then
              'ill health'
            when 'Final salary or career average pensions' then
              'defined benefit pensions'
            end

  expect(page).to include_output_document_section(section)
end
