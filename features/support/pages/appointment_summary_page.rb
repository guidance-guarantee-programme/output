class AppointmentSummaryPage < SitePrism::Page
  set_url '/appointment_summaries/new'

  element :name, '.t-name'
  element :submit, '.t-submit'
end
