class AppointmentSummariesBatch < ActiveRecord::Base
  belongs_to :appointment_summary
  belongs_to :batch
end