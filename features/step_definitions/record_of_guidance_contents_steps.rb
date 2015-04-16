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

  expect_uploaded_csv_to_include(expected)
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

Then(/^it should include information about "(.*?)"$/) do |circumstance|
  column = case circumstance
           when 'Plans to continue working for a while' then :continue_working
           when 'Unsure about plans in retirement'      then :unsure
           when 'Plans to leave money to someone'       then :leave_inheritance
           when 'Wants flexibility when taking money'   then :wants_flexibility
           when 'Wants a guaranteed income'             then :wants_security
           when 'Needs a certain amount of money now'   then :wants_lump_sum
           when 'Has poor health'                       then :poor_health
           end

  expect_uploaded_csv_to_include(column => true)
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
  output_document = OutputDocument.new(@appointment_summary)

  expected = {
    attendee_name: output_document.attendee_name,
    value_of_pension_pots: output_document.value_of_pension_pots
  }

  expect_uploaded_csv_to_include(expected)
end

Given(/^(?:I|we) have captured appointment details in an appointment summary$/) do
  @appointment_summary = fixture(:populated_appointment_summary)
end

Then(/^the record of guidance should include the details of the appointment$/) do
  output_document = OutputDocument.new(@appointment_summary)

  expected = {
    appointment_date: output_document.appointment_date,
    guider_first_name: output_document.guider_first_name,
    guider_organisation: output_document.guider_organisation
  }

  expect_uploaded_csv_to_include(expected)

  appointment_reference = read_uploaded_csv.first[:appointment_reference]
  expect(appointment_reference).to match(/^\d+#{output_document.appointment_reference}/)
end
