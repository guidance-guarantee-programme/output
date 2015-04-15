Given(/^one or more of the predefined circumstances applies to the customer$/) do
  @appointment_summary = fixture(:populated_appointment_summary).tap do |as|
    as.continue_working = true
    as.unsure = false
    as.leave_inheritance = true
    as.wants_flexibility = false
    as.wants_security = true
    as.wants_lump_sum = false
    as.poor_health = true
  end
end

Given(/^(?:I|we) don't know that any of the predefined circumstances apply to the customer$/) do
  @appointment_summary = fixture(:populated_appointment_summary).tap do |as|
    as.continue_working = false
    as.unsure = false
    as.leave_inheritance = false
    as.wants_flexibility = false
    as.wants_security = false
    as.wants_lump_sum = false
    as.poor_health = false
  end
end

When(/^(?:I|we) send (?:them their|a) record of guidance$/) do
  appointment_summary_page = AppointmentSummaryPage.new
  appointment_summary_page.load
  appointment_summary_page.fill_in(@appointment_summary)
  appointment_summary_page.submit.click

  preview_page = RecordOfGuidancePreviewPage.new
  preview_page.confirm.click

  ProcessOutputDocuments.new.call
end

Then(/^the sections it includes should be:$/) do |table|
  sections = table.raw.flatten

  expected =
    case
    when sections.include?('detail about applicable circumstances')
      {
        variant: 'tailored',
        continue_working: @appointment_summary.continue_working?,
        unsure: @appointment_summary.unsure?,
        leave_inheritance: @appointment_summary.leave_inheritance?,
        wants_flexibility: @appointment_summary.wants_flexibility?,
        wants_security: @appointment_summary.wants_security?,
        wants_lump_sum: @appointment_summary.wants_lump_sum?,
        poor_health: @appointment_summary.poor_health?
      }
    when sections.include?('detail about each option')
      {
        variant: 'generic'
      }
    else
      fail "Cannot determine expected variant from sections: #{sections}"
    end

  rows = read_uploaded_csv
  expect(rows.count).to eq(1)
  expect(rows.first.to_hash).to include(expected)
end

Given(/^"(.*?)" applies to the customer$/) do |circumstance|
  @appointment_summary = fixture(:populated_appointment_summary).tap do |as|
    as.continue_working = false
    as.unsure = false
    as.leave_inheritance = false
    as.wants_flexibility = false
    as.wants_security = false
    as.wants_lump_sum = false
    as.poor_health = false
  end

  case circumstance
  when 'Plans to continue working for a while' then @appointment_summary.continue_working = true
  when 'Unsure about plans in retirement'      then @appointment_summary.unsure = true
  when 'Plans to leave money to someone'       then @appointment_summary.leave_inheritance = true
  when 'Wants flexibility when taking money'   then @appointment_summary.wants_flexibility = true
  when 'Wants a guaranteed income'             then @appointment_summary.wants_security = true
  when 'Needs a certain amount of money now'   then @appointment_summary.wants_lump_sum = true
  when 'Has poor health'                       then @appointment_summary.poor_health = true
  end
end

# Then(/^it should include information about "(.*?)"$/) do |circumstance|
#   section = case circumstance
#             when 'Plans to continue working for a while' then 'continue working'
#             when 'Unsure about plans in retirement'      then 'unsure'
#             when 'Plans to leave money to someone'       then 'leave inheritance'
#             when 'Wants flexibility when taking money'   then 'wants flexibility'
#             when 'Wants a guaranteed income'             then 'wants security'
#             when 'Needs a certain amount of money now'   then 'wants lump sum'
#             when 'Has poor health'                       then 'poor health'
#             end

#   expect(page).to include_output_document_section(section)
# end

Given(/^the customer has access to income during retirement from (.*?)$/) do |sources_of_income|
  @appointment_summary = fixture(:populated_appointment_summary).tap do |as|
    as.income_in_retirement = case sources_of_income
                              when 'only their DC pot and state pension' then 'pension'
                              when 'multiple sources'                    then 'other'
                              end
  end
end

# Then(/^the "pension pot" section should be the "(.*?)" version$/) do |version|
#   version = case version
#             when 'only their DC pot and state pension' then 'pension'
#             when 'multiple sources'                    then 'other'
#             end

#   expect(page).to include_output_document_section('pension pot').at_version(version)
# end

Given(/^(?:I|we) have captured the customer's details in an appointment summary$/) do
  @appointment_summary = fixture(:populated_appointment_summary)
end

# Then(/^the record of guidance should include their details$/) do
#   output_document = OutputDocument.new(@appointment_summary)

#   expect(page).to have_content(output_document.attendee_name)
#   expect(page).to have_content(output_document.value_of_pension_pots)
# end

Given(/^(?:I|we) have captured appointment details in an appointment summary$/) do
  @appointment_summary = fixture(:populated_appointment_summary)
end

# Then(/^the record of guidance should include the details of the appointment$/) do
#   output_document = OutputDocument.new(@appointment_summary)

#   expect(page).to have_content(output_document.appointment_date)
#   expect(page).to have_content(output_document.appointment_reference)
#   expect(page).to have_content(output_document.guider_first_name)
#   expect(page).to have_content(output_document.guider_organisation)
# end
