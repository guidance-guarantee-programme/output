class OutputDocumentMailer < ActionMailer::Base
  def issue(appointment_summary, output_document)
    attachments['record_of_guidance.pdf'] = output_document
    mail(
      to: appointment_summary.email_address,
      from: 'guidance@pensionwise.gov.uk',
      subject: 'Record of your guidance'
    )
  end
end
