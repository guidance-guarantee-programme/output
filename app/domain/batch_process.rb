class BatchProcess
  attr_reader :output_documents

  def initialize(output_documents)
    @output_documents = output_documents
  end

  def csv
    [headers].concat(output_documents.map(&:csv)).join
  end

  private

  def headers
    OutputDocument::CSVRenderer::FIELDS.join('|') + "\n"
  end
end
