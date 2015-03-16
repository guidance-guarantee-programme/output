class OutputDocument
  attr_accessor :appointment_summary

  def initialize(appointment_summary)
    @appointment_summary = appointment_summary
  end

  def html
    ERB.new(template).result(binding)
  end

  def pdf
    Princely.new.pdf_from_string(html)
  end

  private

  def template
    File.read(
      File.join(Rails.root, 'app', 'templates', 'output_document.html.erb'))
  end
end
