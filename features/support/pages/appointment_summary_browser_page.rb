# frozen_string_literal: true
class AppointmentSummaryBrowserPage < SitePrism::Page
  set_url '/admin/appointment_summaries'
  set_url_matcher %r{/admin/appointment_summaries}

  sections :appointments, '.t-appointment' do
    element :edit_email, '.t-edit-email'
  end
  elements :pages, 'li.page'

  element :start_date, '.t-start'
  element :end_date, '.t-end'
  element :search_input, '.t-search'

  element :search_button, '.t-search-button'
  element :export_to_csv, '.t-export'
end
