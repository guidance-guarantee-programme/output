Given(/^appointment details are captured$/) do
  @appointment_summary = fixture(:populated_appointment_summary)

  page = AppointmentSummaryPage.new
  page.load
  page.fill_in(@appointment_summary)
  page.submit.click
end

Given(/^I'm on the preview page$/) do
  page = PreviewPage.new

  expect(page).to be_displayed
end

When(/^I go back to the appointment details$/) do
  page = PreviewPage.new

  page.back.click
end

Then(/^the previously captured details are prepopulated$/) do
  page = AppointmentSummaryPage.new

  expect(page.title.value).to eq(@appointment_summary.title)
  expect(page.first_name.value).to eq(@appointment_summary.first_name)
  expect(page.last_name.value).to eq(@appointment_summary.last_name)

  expect(page.address_line_1.value).to eq(@appointment_summary.address_line_1)
  expect(page.address_line_2.value).to eq(@appointment_summary.address_line_2)
  expect(page.address_line_3.value).to eq(@appointment_summary.address_line_3)
  expect(page.town.value).to eq(@appointment_summary.town)
  expect(page.county.value).to eq(@appointment_summary.county)
  expect(page.postcode.value).to eq(@appointment_summary.postcode)

  expect(Time.zone.parse(page.date_of_appointment.value)).to eq(@appointment_summary.date_of_appointment)
  expect(page.reference_number.value).to eq(@appointment_summary.reference_number)

  expect(page.value_of_pension_pots.value).to eq(@appointment_summary.value_of_pension_pots.to_s)
  expect(page.upper_value_of_pension_pots.value).to eq(@appointment_summary.upper_value_of_pension_pots.to_s)

  expect(page.value_of_pension_pots_is_approximate)
    .to have_checked_state(@appointment_summary.value_of_pension_pots_is_approximate?)

  case @appointment_summary.income_in_retirement
  when 'pension'
    expect(page.income_in_retirement_pension).to be_checked
    expect(page.income_in_retirement_other).not_to be_checked
  when 'other'
    expect(page.income_in_retirement_pension).to be_checked
    expect(page.income_in_retirement_other).to be_checked
  end
  expect(page.guider_name.value).to eq(@appointment_summary.guider_name)

  case @appointment_summary.guider_organisation
  when 'tpas'
    expect(page.guider_organisation_tpas).to be_checked
    expect(page.guider_organisation_dwp).not_to be_checked
  when 'dwp'
    expect(page.guider_organisation_tpas).not_to be_checked
    expect(page.guider_organisation_dwp).to be_checked
  end

  case (@appointment_summary.has_defined_contribution_pension)
  when 'yes'
    expect(page.has_defined_contribution_pension_yes).to be_checked
    expect(page.has_defined_contribution_pension_no).not_to be_checked
    expect(page.has_defined_contribution_pension_unknown).not_to be_checked
  when 'no'
    expect(page.has_defined_contribution_pension_yes).not_to be_checked
    expect(page.has_defined_contribution_pension_no).to be_checked
    expect(page.has_defined_contribution_pension_unknown).not_to be_checked
  when 'unkown'
    expect(page.has_defined_contribution_pension_yes).not_to be_checked
    expect(page.has_defined_contribution_pension_no).not_to be_checked
    expect(page.has_defined_contribution_pension_unknown).to be_checked
  end

  expect(page.continue_working).to have_checked_state(@appointment_summary.continue_working?)
  expect(page.unsure).to have_checked_state(@appointment_summary.unsure?)
  expect(page.leave_inheritance).to have_checked_state(@appointment_summary.leave_inheritance?)
  expect(page.wants_flexibility).to have_checked_state(@appointment_summary.wants_flexibility?)
  expect(page.wants_security).to have_checked_state(@appointment_summary.wants_security?)
  expect(page.wants_lump_sum).to have_checked_state(@appointment_summary.wants_lump_sum?)
  expect(page.poor_health).to have_checked_state(@appointment_summary.poor_health?)

  case @appointment_summary.format_preference
  when 'standard'
    expect(page.format_preference_standard).to be_checked
    expect(page.format_preference_large_text).not_to be_checked
    expect(page.format_preference_braille).not_to be_checked
  when 'large_text'
    expect(page.format_preference_standard).not_to be_checked
    expect(page.format_preference_large_text).to be_checked
    expect(page.format_preference_braille).not_to be_checked
  when 'braille'
    expect(page.format_preference_standard).not_to be_checked
    expect(page.format_preference_large_text).not_to be_checked
    expect(page.format_preference_braille).to be_checked
  end
end
