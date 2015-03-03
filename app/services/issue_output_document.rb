class IssueOutputDocument
  attr_accessor :appointment_summary

  def initialize(appointment_summary)
    @appointment_summary = appointment_summary
  end

  def call
    return unless @appointment_summary.email_address.present?

    output_document = OutputDocument.new(@appointment_summary)
    OutputDocumentMailer.issue(@appointment_summary, output_document.pdf)
      .deliver_later
  end
end
