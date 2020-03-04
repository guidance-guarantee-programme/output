namespace :confidentiality do # rubocop:disable BlockLength
  desc 'Redact customer details (REFERENCE=x TELEPHONE=true)'
  task redact: :environment do
    reference   = ENV.fetch('REFERENCE')
    telephone   = ENV.fetch('TELEPHONE') { false }
    appointment = AppointmentSummary.find_by(reference_number: reference, telephone_appointment: telephone)
    REDACTED    = 'REDACTED'.freeze

    if appointment
      appointment.assign_attributes(
        title: '',
        first_name: REDACTED,
        last_name: REDACTED,
        value_of_pension_pots: 0,
        upper_value_of_pension_pots: 0,
        address_line_1: REDACTED,
        address_line_2: REDACTED,
        address_line_3: REDACTED,
        town: REDACTED,
        county: REDACTED,
        postcode: REDACTED,
        email: REDACTED
      )

      appointment.save(validate: false)

      puts 'The appointment summary was redacted'
    else
      puts 'Nothing found for the given `REFERENCE`'
    end
  end
end
