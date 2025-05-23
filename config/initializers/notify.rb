# frozen_string_literal: true
Rails.configuration.x.notify.tap do |notify|
  notify.secret_id = ENV['NOTIFY_SECRET_ID']
  notify.appointment_summary_template_id = ENV['APPOINTMENT_SUMMARY_TEMPLATE_ID']
  notify.welsh_appointment_summary_template_id = ENV['WELSH_APPOINTMENT_SUMMARY_TEMPLATE_ID']
  notify.ineligible_template_id = ENV['INELIGIBLE_TEMPLATE_ID']
  notify.welsh_ineligible_template_id = ENV['WELSH_INELIGIBLE_TEMPLATE_ID']

  notify.due_diligence_secret_id = ENV['DUE_DILIGENCE_SECRET_ID']
  notify.due_diligence_summary_template_id = ENV['DUE_DILIGENCE_SUMMARY_TEMPLATE_ID']

  notify.standard_pdf_download_url = ENV['STANDARD_PDF_DOWNLOAD_URL']
  notify.non_standard_pdf_download_url = ENV['NON_STANDARD_PDF_DOWNLOAD_URL']
  notify.standard_db_pdf_download_url = ENV['STANDARD_DB_PDF_DOWNLOAD_URL']
  notify.non_standard_db_pdf_download_url = ENV['NON_STANDARD_DB_PDF_DOWNLOAD_URL']
end
