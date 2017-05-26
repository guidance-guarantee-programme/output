require 'rails_helper'

RSpec.feature 'Browsing appointment summaries' do
  scenario 'Viewing the Appointment Summaries' do
    given_i_am_logged_in_as_a_pension_wise_administrator
    and_there_are_existing_appointment_summaries
    when_i_visit_the_summary_browser
    then_i_am_presented_with_appointment_summaries
    and_i_see_there_are_multiple_pages
    and_the_date_range_is_displayed
  end

  scenario 'Exporting the Appointment Summaries to CSV' do
    given_i_am_logged_in_as_a_pension_wise_administrator
    and_there_are_existing_appointment_summaries
    when_i_visit_the_summary_browser
    and_i_export_the_results_to_csv
    then_i_am_prompted_to_download_a_csv
  end

  scenario 'Attempting to view the Appointment Summaries' do
    given_i_am_logged_but_not_a_pension_wise_administrator
    when_i_visit_the_summary_browser
    then_i_am_denied_access
  end
end

def given_i_am_logged_in_as_a_pension_wise_administrator
  create(:user, permissions: ['analyst'])
end

def given_i_am_logged_but_not_a_pension_wise_administrator
  create(:user, permissions: ['signon'])
end

def and_there_are_existing_appointment_summaries
  create_list(
    :appointment_summary,
    Kaminari.config.default_per_page + 1
  )
end

def when_i_visit_the_summary_browser
  @page = AppointmentSummaryBrowserPage.new
  @page.load
end

def then_i_am_denied_access
  expect(@page).to_not be_displayed
end

def and_i_export_the_results_to_csv
  @page.export_to_csv.click
end

def then_i_am_presented_with_appointment_summaries
  expect(@page).to have_appointments(count: Kaminari.config.default_per_page)
end

def and_i_see_there_are_multiple_pages
  expect(@page).to have_pages
end

def and_the_date_range_is_displayed
  expect(@page.start_date.value).to be_present
  expect(@page.end_date.value).to be_present
end

def then_i_am_prompted_to_download_a_csv
  expect(page.response_headers).to include(
    'Content-Disposition' => 'attachment; filename=data.csv',
    'Content-Type'        => 'text/csv'
  )
end
