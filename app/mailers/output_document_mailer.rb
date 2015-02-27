class OutputDocumentMailer < ActionMailer::Base
  def guidance_record(appointment_summary)
    output_document = OutputDocument.new(appointment_summary).content

    attachments['record_of_guidance.pdf'] = output_document
    mail(
      to: appointment_summary.email_address,
      from: 'guidance@pensionwise.gov.uk',
      subject: 'Record of your guidance'
    )
  end
end
