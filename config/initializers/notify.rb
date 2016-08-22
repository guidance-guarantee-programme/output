# frozen_string_literal: true
Rails.configuration.x.notify.tap do |notify|
  notify.service_id = ENV['NOTIFY_SERVICE_ID']
  notify.secret_id = ENV['NOTIFY_SECRET_ID']
  notify.appointment_summary_template_id = ENV['APPOINTMENT_SUMMARY_TEMPLATE_ID']
  notify.ineligible_template_id = ENV['INELIGIBLE_TEMPLATE_ID']
end
