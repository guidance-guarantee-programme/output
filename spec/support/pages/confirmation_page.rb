# frozen_string_literal: true
class ConfirmationPage < SitePrism::Page
  set_url_matcher %r{/appointment_summaries/confirm}

  element :unique_reference_number, '.t-unique-reference-number'
  element :guider_name, '.t-guider-name'
  element :name, '.name'
  element :confirm, '.t-confirm'
  element :back, '.t-back'
end
