class AppointmentSummary < ActiveRecord::Base
  validates :name, presence: true
end
