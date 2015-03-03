class AppointmentSummary < ActiveRecord::Base
  validates :name, presence: true
  validates :email_address, format: RFC822::EMAIL, allow_blank: true
  validates :date_of_appointment, timeliness: { on_or_before: -> { Date.current },
                                                on_or_after: Date.new(2015),
                                                type: :date }
  validates :value_of_pension_pots, presence: true, numericality: true
  validates :income_in_retirement, inclusion: { in: %w(pension other) }
end
