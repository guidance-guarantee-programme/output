require 'csv'

class OutputDocument
  class CSVRowRenderer
    attr_accessor :output_document

    FIELDS = %i(id format variant attendee_name attendee_address_line_1
                attendee_address_line_2 attendee_address_line_3 attendee_town
                attendee_county attendee_postcode lead guider_first_name
                guider_organisation appointment_reference appointment_date
                value_of_pension_pots income_in_retirement continue_working
                unsure leave_inheritance wants_flexibility wants_security
                wants_lump_sum poor_health)

    def initialize(output_document)
      @output_document = output_document
    end

    def render
      CSV.generate(col_sep: '|', encoding: 'iso-8859-1') do |csv|
        csv << FIELDS.map { |field| output_document.public_send(field) }
      end
    end
  end
end
