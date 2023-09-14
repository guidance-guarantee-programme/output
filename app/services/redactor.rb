class Redactor
  REDACTED = 'REDACTED'.freeze

  def initialize(reference)
    @reference = reference
  end

  def call
    return unless appointment_summary = AppointmentSummary.find(reference) # rubocop:disable Lint/AssignmentInCondition

    ActiveRecord::Base.transaction do
      appointment_summary.assign_attributes(redacted_attributes)
      appointment_summary.save(validate: false)
    end
  end

  def self.redact_for_gdpr
    AppointmentSummary.for_redaction.pluck(:id).each do |reference|
      new(reference).call
    end
  end

  private

  def redacted_attributes
    {
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
    }
  end

  attr_reader :reference
end
