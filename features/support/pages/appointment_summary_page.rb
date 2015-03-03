class AppointmentSummaryPage < SitePrism::Page
  set_url '/appointment_summaries/new'

  element :name, '.t-name'
  element :email_address, '.t-email-address'
  element :date_of_appointment, '.t-date-of-appointment'
  element :submit, '.t-submit'
end
