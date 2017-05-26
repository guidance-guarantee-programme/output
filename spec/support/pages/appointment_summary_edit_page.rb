# frozen_string_literal: true
class AppointmentSummaryEditPage < SitePrism::Page
  set_url '/admin/appointment_summaries/%{id}/edit'

  element :email, '.t-email'

  element :save_and_resend_email, '.t-save-and-resend'
end
