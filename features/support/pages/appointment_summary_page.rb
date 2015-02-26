class AppointmentSummaryPage < SitePrism::Page
  set_url '/appointment_summaries/new'

  element :name, '.t-name'
  element :email_address, '.t-email-address'
  element :submit, '.t-submit'
end
