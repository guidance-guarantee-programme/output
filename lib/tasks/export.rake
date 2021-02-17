namespace :export do
  desc 'Export CSV data to blob storage for analysis'
  task blob: :environment do
    from_timestamp = ENV.fetch('FROM') { 3.months.ago }

    AppointmentSummary.public_send(:acts_as_copy_target)

    data = AppointmentSummary
           .joins(:user)
           .where(
             'appointment_summaries.created_at >= :ts  or appointment_summaries.updated_at >= :ts', ts: from_timestamp
           )
           .select(
             "appointment_summaries.id, reference_number, telephone_appointment,
              users.organisation_content_id as organisation_id,
              date_of_appointment, substring(postcode from '([A-z]{1,2})[0-9]') as postcode,
              country, appointment_type, has_defined_contribution_pension,
              requested_digital, appointment_summaries.created_at, appointment_summaries.updated_at"
           ).order(:created_at).copy_to_string

    client = Azure::Storage::Blob::BlobService.create_from_connection_string(
      ENV.fetch('AZURE_CONNECTION_STRING')
    )

    client.create_block_blob(
      'pw-prd-data',
      "/To_Be_Processed/MAPS_PWBLZ_DOCSUMMARY_#{Time.current.strftime('%Y%m%d%H%M%S')}.csv",
      data
    )
  end
end
