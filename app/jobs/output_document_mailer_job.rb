class OutputDocumentMailerJob < ActiveJob::Base
  def perform(appointment_summary)
    output_document = OutputDocument.new(appointment_summary)
    OutputDocumentMailer.issue(appointment_summary, output_document.pdf).deliver_now
  end
end
