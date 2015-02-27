class OutputDocument
  include Rails.application.routes.url_helpers

  attr_accessor :appointment_summary

  def initialize(appointment_summary)
    @appointment_summary = appointment_summary
  end

  def content
    app = ActionDispatch::Integration::Session.new(Rails.application)
    path = appointment_summary_path(appointment_summary, format: :pdf)
    app.get(path)
    app.response.body
  end
end
