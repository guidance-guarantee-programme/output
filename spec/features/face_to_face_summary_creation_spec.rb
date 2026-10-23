require 'rails_helper'

RSpec.feature 'Face to face appointment summary creation' do
  before { ActiveJob::Base.queue_adapter.enqueued_jobs.clear }

  scenario 'Attempting to create a summary from scratch' do
    given_i_am_logged_in_as_a_face_to_face_guider
    when_i_load_the_blank_summary_form
    then_i_am_told_to_use_planner
  end

  scenario 'When I do not have the required permissions' do
    given_i_am_logged_in_as_a_non_f2f_guider
    when_the_guider_follows_the_planner_summary_link
    then_they_see_the_permissions_error
  end

  scenario 'As a face to face guider' do
    given_i_am_logged_in_as_a_face_to_face_guider
    when_the_guider_follows_the_planner_summary_link
    then_the_details_provided_by_planner_are_displayed
    and_i_complete_the_summary_form_with_preset_digital_delivery_data
    then_i_am_able_to_submit_and_confirm_successfully
    and_the_customer_should_be_notified_by_email
    and_no_activity_should_be_created_on_tap
    and_an_activity_should_be_created_on_planner
  end

  def when_i_load_the_blank_summary_form
    @page = AppointmentSummaryPage.new
    @page.load
  end

  def given_i_am_logged_in_as_a_non_f2f_guider
    create(:user, :phone_guider)
  end

  def given_i_am_logged_in_as_a_face_to_face_guider
    create(:user, :face_to_face_guider)
  end

  def when_the_guider_follows_the_planner_summary_link
    @page = AppointmentSummaryPage.new.tap do |page|
      page.load(
        date_of_appointment: '2017-02-02',
        email: 'george@example.com',
        first_name: 'George',
        last_name: 'Georgeson',
        guider_name: 'Jan Janson',
        number_of_previous_appointments: '0',
        reference_number: '123456',
        telephone_appointment: 'false',
        welsh: 'false'
      )
    end
  end

  def then_they_see_the_permissions_error
    expect(@page).to have_content('You need the face-to-face guider permission')
  end

  def then_the_details_provided_by_planner_are_displayed
    expect(@page).to be_displayed

    expect(@page.reference_number.value).to eq('123456')
    expect(@page.date_of_appointment.value).to eq('2017-02-02')
    expect(@page.email.value).to eq('george@example.com')
    expect(@page.first_name.value).to eq('George')
    expect(@page.last_name.value).to eq('Georgeson')
    expect(@page.guider_name.value).to eq('Jan Janson')
    expect(@page.welsh.selected_value).to eq('false')
  end

  def then_i_am_told_to_use_planner
    expect(@page).to have_use_planner_warning
  end

  def and_i_complete_the_summary_form_with_preset_digital_delivery_data
    template = build(:populated_appointment_summary, :requested_digital)
    @page.fill_in(template, face_to_face: true)
  end

  def then_i_am_able_to_submit_and_confirm_successfully
    @page.submit.click

    @confirmation_page = ConfirmationPage.new
    @confirmation_page.confirm.click

    @done_page = DonePage.new
    expect(@done_page).to be_displayed
  end

  def and_the_customer_should_be_notified_by_email
    assert_enqueued_jobs 1, only: NotifyViaEmail
  end

  def and_no_activity_should_be_created_on_tap
    assert_enqueued_jobs 0, only: CreateTapActivity
  end

  def and_an_activity_should_be_created_on_planner
    assert_enqueued_jobs 1, only: CreatePlannerActivity
  end
end
