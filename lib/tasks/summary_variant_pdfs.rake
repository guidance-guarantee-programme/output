class OutputDocument
  attr_reader :filename, :supplementary_defined_benefit_pensions

  def initialize(filename:, type:, welsh:, supplementary_defined_benefit_pensions:)
    @filename = filename
    @type = type
    @welsh = welsh
    @supplementary_defined_benefit_pensions = supplementary_defined_benefit_pensions
  end

  def welsh?
    @welsh
  end

  def appointment_type
    @type
  end

  def envelope_class
    'l-envelope--tpas'
  end

  def format_preference
    'standard'
  end

  def next_steps?
    false
  end

  def supplementary_benefits
    true
  end

  def supplementary_debt
    true
  end

  def supplementary_ill_health
    true
  end

  def supplementary_pension_transfers
    true
  end

  def covering_letter_type
    ''
  end

  def variant
    'generic'
  end

  def generate_pdf
    html = Output::Templates.template('generic').render(self)
    Princely::Pdf.new.pdf_from_string_to_file(html, "/tmp/#{filename}")

    puts "Written PDF: #{filename}"
  end
end

# rubocop:disable Metrics/BlockLength
namespace :summary_variants do
  task pdfs: :environment do
    [
      OutputDocument.new(
        filename: 'standard.pdf', type: 'standard', welsh: false, supplementary_defined_benefit_pensions: false
      ),
      OutputDocument.new(
        filename: 'standard-cy.pdf', type: 'standard', welsh: true, supplementary_defined_benefit_pensions: false
      ),
      OutputDocument.new(
        filename: 'standard-db.pdf', type: 'standard', welsh: false, supplementary_defined_benefit_pensions: true
      ),
      OutputDocument.new(
        filename: 'standard-db-cy.pdf', type: 'standard', welsh: true, supplementary_defined_benefit_pensions: true
      ),
      OutputDocument.new(
        filename: 'non-standard.pdf', type: '50_54', welsh: false, supplementary_defined_benefit_pensions: false
      ),
      OutputDocument.new(
        filename: 'non-standard-cy.pdf', type: '50_54', welsh: true, supplementary_defined_benefit_pensions: false
      ),
      OutputDocument.new(
        filename: 'non-standard-db.pdf', type: '50_54', welsh: false, supplementary_defined_benefit_pensions: true
      ),
      OutputDocument.new(
        filename: 'non-standard-db-cy.pdf', type: '50_54', welsh: true, supplementary_defined_benefit_pensions: true
      )
    ].each(&:generate_pdf)
  end
end
# rubocop:enable Metrics/BlockLength
