class OutputDocumentMailer < ActionMailer::Base
  def issue(appointment_summary, output_document)
    @appointment_summary = appointment_summary
    @subject = 'Record of your guidance'

    attachments['record_of_guidance.pdf'] = output_document
    mail(
      to: appointment_summary.email_address,
      from: 'guidance@pensionwise.gov.uk',
      subject: @subject
    )
  end
end
