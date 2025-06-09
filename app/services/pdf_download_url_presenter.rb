class PdfDownloadUrlPresenter
  def initialize(appointment_summary, config)
    @appointment_summary = appointment_summary
    @config = config
  end

  def call
    return '' unless appointment_summary.eligible_for_guidance?

    standard = appointment_summary.standard? ? 'standard' : 'non-standard'
    db       = appointment_summary.supplementary_defined_benefit_pensions ? '-db' : ''
    locale   = appointment_summary.welsh? ? '-cy' : ''
    filename = "#{standard}#{db}#{locale}.pdf"

    [config.pdf_download_host, filename].join('/')
  end

  private

  attr_reader :appointment_summary, :config
end
