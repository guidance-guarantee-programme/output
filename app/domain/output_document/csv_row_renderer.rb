require 'csv'

class OutputDocument
  class CSVRowRenderer
    attr_accessor :output_document

    def initialize(output_document)
      @output_document = output_document
    end

    def render
      CSV.generate(col_sep: '|', encoding: 'utf-8') do |csv|
        csv << CSVRenderer.headers.map { |field| output_document.public_send(field) }
      end
    end
  end
end
