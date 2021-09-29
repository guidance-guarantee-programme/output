require 'rails_helper'

RSpec.feature 'Due diligence appointment summary', js: true do
  scenario 'Generating via a completed TAP record' do
    given_a_logged_in_phone_guider
    when_they_attempt_to_generate_a_summary_via_tap
    then_the_summary_is_presented_with_the_correct_fields
    when_they_complete_the_summary_document
    then_the_appointment_summary_is_created
  end

  def given_a_logged_in_phone_guider
    create(:user, :phone_guider)
  end

  def when_they_attempt_to_generate_a_summary_via_tap # rubocop:disable MethodLength
    @page = AppointmentSummaryPage.new.tap do |page|
      page.load(
        first_name: 'Daisy',
        last_name: 'Lovell',
        date_of_appointment: '2021-03-10',
        guider_name: 'Rebecca',
        reference_number: '123456',
        number_of_previous_appointments: '0',
        email: 'daisy@example.com',
        appointment_type: 'standard',
        address_line_1: '1 Some Road',
        address_line_2: 'Some Street',
        address_line_3: '',
        town: 'Reading',
        county: 'Berkshire',
        postcode: 'RG1 1AB',
        country: 'United Kingdom',
        telephone_appointment: 'true',
        schedule_type: 'due_diligence',
        unique_reference_number: '123456/100321'
      )
    end
  end

  def then_the_summary_is_presented_with_the_correct_fields
    expect(@page).to be_displayed

    expect(@page).to have_no_value_of_pension_pots
    expect(@page).to have_no_first_appointment_yes
    expect(@page).to have_no_has_defined_contribution_pension_yes
    expect(@page).to have_no_guider_name
  end

  def when_they_complete_the_summary_document
    @page.title.select('Ms')
    @page.submit.click

    @page = ConfirmationPage.new
    expect(@page).to be_displayed
    @page.confirm.click
  end

  def then_the_appointment_summary_is_created
    expect(AppointmentSummary.last).to have_attributes(
      schedule_type: 'due_diligence',
      unique_reference_number: '123456/100321'
    )
  end
end
