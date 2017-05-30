require 'rails_helper'

RSpec.feature 'Reprint Summary Document' do
  scenario 'Reprint a summary doc' do
    given_i_log_in_to_reprint_a_summary_document
    when_i_search_for_a_reference_number
    and_i_select_the_record_matching_the_customers_details
    then_i_am_able_to_edit_the_customers_details
    and_i_can_reprint_the_customers_summary_document
  end

  scenario 'Postal summary document requests report' do
    given_i_log_in_to_see_a_report_of_summary_documents_sent_by_post
    when_i_search_for_postal_summary_documents_for_today
    then_i_can_see_the_list_of_postal_summary_documents
    and_i_can_reprint_any_of_the_summary_documents_for_the_day
  end
end

def given_i_log_in_to_reprint_a_summary_document
  @user = create(:user, :team_leader)
  @appointment_summary = create(:appointment_summary)
end

def given_i_log_in_to_see_a_report_of_summary_documents_sent_by_post
  @user = create(:user, :team_leader)

  create(:appointment_summary, requested_digital: true)
  create(:appointment_summary, date_of_appointment: Time.zone.yesterday)

  @appointment_summaries = create_list(:appointment_summary, 2, requested_digital: false)
end

def when_i_search_for_a_reference_number
  @page = AppointmentSummariesPage.new
  @page.load
  @page.search(@appointment_summary.reference_number)
end

def when_i_search_for_postal_summary_documents_for_today
  @page = AppointmentSummariesPage.new
  @page.load
  @page.search_date(Time.zone.today)
end

def and_i_select_the_record_matching_the_customers_details
  appointment = @page.appointments.first
  expect(appointment.reference_number.text).to eq(@appointment_summary.reference_number)
  appointment.reprint_button.click
end

def then_i_am_able_to_edit_the_customers_details
  @page = AppointmentSummaryPage.new
  expect(@page).to be_displayed
end

def then_i_can_see_the_list_of_postal_summary_documents
  reference_numbers = @page.appointments.map { |a| a.reference_number.text }
  expect(reference_numbers).to eq(@appointment_summaries.map(&:reference_number))
end

def and_i_can_reprint_the_customers_summary_document
  @page.submit.click
  expect(@page).not_to be_displayed
end

def and_i_can_reprint_any_of_the_summary_documents_for_the_day
  @page.appointments.each do |appointment_summary|
    expect(appointment_summary).to have_reprint_button
  end
end
