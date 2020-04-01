require 'rails_helper'

RSpec.describe Redactor do
  include ActiveSupport::Testing::TimeHelpers

  describe '.redact_for_gdpr' do
    it 'redacts records yet to be redacted, greater than 2 years old' do
      travel_to '2018-02-28 10:00' do
        @redacted = create(:appointment_summary, first_name: Redactor::REDACTED)
        @included = create(:appointment_summary)
      end

      travel_to '2020-01-01 10:00' do
        @excluded = create(:appointment_summary)
      end

      travel_to '2020-03-31 10:00' do
        described_class.redact_for_gdpr
      end

      # was redacted
      expect(@included.reload.created_at).not_to eq(@included.updated_at)
      # was already redacted so not updated
      expect(@redacted.reload.created_at).to eq(@redacted.updated_at)
      # was outside the date range so not updated
      expect(@excluded.reload.created_at).to eq(@excluded.updated_at)
    end
  end

  describe '#call' do
    it 'redacts all personally identifying information' do
      summary     = create(:appointment_summary)
      redactor    = described_class.new(summary.id)

      redactor.call

      expect(summary.reload).to have_attributes(
        title: '',
        first_name: Redactor::REDACTED,
        last_name: Redactor::REDACTED,
        value_of_pension_pots: 0,
        upper_value_of_pension_pots: 0,
        address_line_1: Redactor::REDACTED,
        address_line_2: Redactor::REDACTED,
        address_line_3: Redactor::REDACTED,
        town: Redactor::REDACTED,
        county: Redactor::REDACTED,
        postcode: Redactor::REDACTED,
        email: Redactor::REDACTED
      )
    end
  end
end
