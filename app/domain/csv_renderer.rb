class CSVRenderer
  attr_reader :output_documents

  def self.headers
    %i(id format variant attendee_name attendee_address_line_1
       attendee_address_line_2 attendee_address_line_3 attendee_town
       attendee_county attendee_postcode lead guider_first_name
       guider_organisation appointment_reference appointment_date
       income_in_retirement)
  end

  def initialize(output_documents)
    @output_documents = output_documents
  end

  def render
    rows = output_documents.reduce([self.class.headers]) do |result, output_document|
      result << array_from(output_document)
    end

    rows.map { |row| render_row(row) }.join("\n")
  end

  private

  def render_row(row)
    row
      .map(&:to_s)
      .map { |value| sanitise(value) }
      .join('|')
  end

  def array_from(output_document)
    self.class.headers.map { |h| output_document.public_send(h) }
  end

  def sanitise(string)
    string.gsub(/[|\n]/, '').strip
  end
end
