require 'csv'

class CSVRenderer
  attr_reader :output_documents

  def self.headers
    %i(id format variant attendee_name attendee_address_line_1
       attendee_address_line_2 attendee_address_line_3 attendee_town
       attendee_county attendee_postcode lead guider_first_name
       guider_organisation appointment_reference appointment_date
       value_of_pension_pots income_in_retirement continue_working unsure
       leave_inheritance wants_flexibility wants_security wants_lump_sum
       poor_health)
  end

  def initialize(output_documents)
    @output_documents = output_documents
  end

  def header_row
    CSV.generate(col_sep: '|', encoding: 'utf-8') do |csv|
      csv << self.class.headers
    end
  end

  def render
    [header_row].concat(output_documents.map(&:csv)).join
  end
end
