require 'rails_helper'

RSpec.feature 'Appointment Summaries', js: true do
  scenario 'Attempting to summarise a phone appointment without the correct permissions' do
    given_i_am_logged_in_as_a_face_to_face_guider
    when_the_guider_follows_the_tap_summary_link
    then_they_are_told_they_do_not_have_the_correct_permissions
  end

  scenario 'Regenerating an existing appointment summary' do
    given_i_am_logged_in_as_a_phone_guider
    and_an_existing_appointment_summary
    when_the_guider_attempts_to_regenerate_the_summary
    then_the_existing_appointment_summary_is_displayed
    and_the_details_provided_by_tap_are_displayed
    when_the_guider_modifies_the_summary
    then_the_confirmation_is_displayed
    when_the_guider_confirms_the_details
    then_the_existing_summary_is_updated
  end

  def given_i_am_logged_in_as_a_face_to_face_guider
    create(:user, :face_to_face_guider)
  end

  def when_the_guider_follows_the_tap_summary_link
    @page = AppointmentSummaryPage.new.tap do |page|
      page.load(
        date_of_appointment: '2017-02-02',
        email: 'george@example.com',
        first_name: 'George',
        last_name: 'Georgeson',
        guider_name: 'Jan Janson',
        number_of_previous_appointments: '0',
        reference_number: '123456',
        telephone_appointment: 'true',
        welsh: 'false'
      )
    end
  end

  def then_they_are_told_they_do_not_have_the_correct_permissions
    expect(@page).to have_tap_permission_warning
  end

  def given_i_am_logged_in_as_a_phone_guider
    create(:user, :phone_guider)
  end

  def and_an_existing_appointment_summary
    @summary = create(:appointment_summary, reference_number: '123456')
  end

  def when_the_guider_attempts_to_regenerate_the_summary
    @page = AppointmentSummaryPage.new.tap do |page|
      page.load(
        appointment_type: 'standard',
        date_of_appointment: '2017-02-02',
        email: 'george@example.com',
        first_name: 'George',
        last_name: 'Georgeson',
        guider_name: 'Jan Janson',
        number_of_previous_appointments: '0',
        reference_number: '123456',
        welsh: 'false'
      )
    end
  end

  def then_the_existing_appointment_summary_is_displayed
    # check only a sample of existing attributes
    expect(@page.address_line_1.value).to eq(@summary.address_line_1)
    expect(@page.postcode.value).to eq(@summary.postcode)
  end

  def and_the_details_provided_by_tap_are_displayed
    expect(@page.reference_number.value).to eq('123456')
    expect(@page.appointment_type_standard).to be_checked
    expect(@page.date_of_appointment.value).to eq('2017-02-02')
    expect(@page.email.value).to eq('george@example.com')
    expect(@page.first_name.value).to eq('George')
    expect(@page.last_name.value).to eq('Georgeson')
    expect(@page.guider_name.value).to eq('Jan Janson')
    expect(@page.welsh.selected_value).to eq('false')
  end

  def when_the_guider_modifies_the_summary
    @page.address_line_1.set('5 Grange Hill')
    @page.submit.click
  end

  def then_the_confirmation_is_displayed
    @page = ConfirmationPage.new
    expect(@page).to be_displayed
  end

  def when_the_guider_confirms_the_details
    @page.confirm.click
  end

  def then_the_existing_summary_is_updated
    @page = DonePage.new
    expect(@page).to be_displayed

    expect(@summary.reload.address_line_1).to eq('5 Grange Hill')
  end
end
