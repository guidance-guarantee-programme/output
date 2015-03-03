class IssueOutputDocument
  attr_accessor :appointment_summary

  def initialize(appointment_summary)
    @appointment_summary = appointment_summary
  end

  def call
    return unless @appointment_summary.email_address.present?

    OutputDocumentMailerJob.perform_later(@appointment_summary)
  end
end
