When(/^I preview (?:their|a) record of guidance$/) do
  page = AppointmentSummaryPage.new
  page.load
  page.fill_in(@appointment_summary)
  page.submit.click
end

Then(/^the sections that the preview includes should be \(in order\):$/) do |table|
  sections = table.raw.flatten

  if (index = sections.index('detail about applicable circumstances'))
    circumstances = []
    circumstances << 'continue working' if @appointment_summary.continue_working?
    circumstances << 'unsure' if @appointment_summary.unsure?
    circumstances << 'leave inheritance' if @appointment_summary.leave_inheritance?
    circumstances << 'wants flexibility' if @appointment_summary.wants_flexibility?
    circumstances << 'wants security' if @appointment_summary.wants_security?
    circumstances << 'wants lump sum' if @appointment_summary.wants_lump_sum?
    circumstances << 'poor health' if @appointment_summary.poor_health?

    sections[index] = circumstances
    sections.flatten!
  end

  expect(page).to include_output_document_sections(sections)
end

Then(/^the preview should include information about "(.*?)"$/) do |circumstance|
  section = case circumstance
            when 'Plans to continue working for a while' then 'continue working'
            when 'Unsure about plans in retirement'      then 'unsure'
            when 'Plans to leave money to someone'       then 'leave inheritance'
            when 'Wants flexibility when taking money'   then 'wants flexibility'
            when 'Wants a guaranteed income'             then 'wants security'
            when 'Needs a certain amount of money now'   then 'wants lump sum'
            when 'Has poor health'                       then 'poor health'
            end

  expect(page).to include_output_document_section(section)
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
