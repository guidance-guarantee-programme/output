class AppointmentSummarySerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attribute :reference_number, key: :reference
  attribute :full_name, key: :name

  attribute :url do
    edit_admin_appointment_summary_url(object)
  end

  attribute :application do
    'Summary Document Generator'
  end
end
