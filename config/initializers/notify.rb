# frozen_string_literal: true
Rails.configuration.x.notify.tap do |notify|
  notify.secret_id = ENV['NOTIFY_SECRET_ID']
  notify.appointment_summary_template_id = ENV['APPOINTMENT_SUMMARY_TEMPLATE_ID']
  notify.ineligible_template_id = ENV['INELIGIBLE_TEMPLATE_ID']

  notify.due_diligence_secret_id = ENV['DUE_DILIGENCE_SECRET_ID']
  notify.due_diligence_summary_template_id = ENV['DUE_DILIGENCE_SUMMARY_TEMPLATE_ID']
end
