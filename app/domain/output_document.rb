class OutputDocument
  include ActionView::Helpers::NumberHelper

  attr_accessor :appointment_summary

  def initialize(appointment_summary)
    @appointment_summary = appointment_summary
  end

  def attendee_name
    "#{appointment_summary.title} #{appointment_summary.first_name} #{appointment_summary.last_name}".squish
  end

  def appointment_date
    appointment_summary.date_of_appointment.to_s(:long)
  end

  def html
    ERB.new(template).result(binding)
  end

  def csv
    'c,s,v'
  end

  private

  def template
    File.read(
      File.join(Rails.root, 'app', 'templates', 'output_document.html.erb'))
  end
end
