# frozen_string_literal: true
class EmailConfirmationPage < SitePrism::Page
  set_url_matcher %r{/appointment_summaries/email_confirmation}

  element :email, '.t-email'
  element :confirm, '.t-confirm'
end
