class AppointmentSummaryBrowserPage < SitePrism::Page
  set_url '/admin/appointment_summaries'
  set_url_matcher %r{/admin/appointment_summaries}

  elements :appointments, '.t-appointment'
  elements :pages, 'li.page'

  element :start_date, '.t-start'
  element :end_date, '.t-end'
  element :export_to_csv, '.t-export'
end
