class AppointmentSummary < ActiveRecord::Base
  validates :name, presence: true
  validates :email_address, format: RFC822::EMAIL, allow_blank: true
end
