# frozen_string_literal: true
class ConfirmationPage < SitePrism::Page
  set_url_matcher %r{/appointment_summaries/confirm}

  element :name, '.name'
  element :confirm, '.t-confirm'
  element :back, '.t-back'
end
