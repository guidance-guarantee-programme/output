# frozen_string_literal: true
require 'json'
require 'uri'

class AppointmentSummary < ActiveRecord::Base
  DIGITAL_BY_DEFAULT_START_DATE = Date.new(2016, 6, 21)
  EMAIL_REGEXP = Regexp.union(
    /\A[^\@\s]+@[^\@\.\s]+(\.[^\@\.\s]+)+$/,
    /\A\z/
  )

  scope :unbatched, lambda {
    includes(:appointment_summaries_batches)
      .where(appointment_summaries_batches: { appointment_summary_id: nil })
  }
  scope :excluding_digital_by_default, lambda {
    where(
      %(
        appointment_summaries.requested_digital IS FALSE
        OR appointment_summaries.date_of_appointment < ?
      ),
      DIGITAL_BY_DEFAULT_START_DATE
    )
  }

  def postcode=(str)
    if str.blank?
      super
    else
      super UKPostcode.parse(str).to_s
    end
  end

  TITLES = %w(Mr Mrs Miss Ms Mx Dr Reverend).freeze

  belongs_to :user
  has_many :appointment_summaries_batches, dependent: :destroy

  validates :title, presence: true, inclusion: { in: TITLES, allow_blank: true }
  validates :last_name, presence: true
  validates :date_of_appointment, timeliness: { on_or_before: -> { Time.zone.today },
                                                on_or_after: Date.new(2015),
                                                type: :date }
  validates :reference_number, numericality: { only_integer: true, allow_blank: true }, presence: true

  with_options numericality: true, allow_blank: true, if: :eligible_for_guidance? do |eligible|
    eligible.validates :value_of_pension_pots
    eligible.validates :upper_value_of_pension_pots
  end

  validates :income_in_retirement, inclusion: { in: %w(pension other) }, if: :eligible_for_guidance?
  validates :guider_name, presence: true
  validates :guider_organisation,
            presence: true,
            inclusion: {
              in: %w(tpas dwp),
              allow_blank: true,
              message: '%{value} is not a valid organisation'
            }

  validates :address_line_1, presence: true, length: { maximum: 50 }
  validates :address_line_2, length: { maximum: 50 }
  validates :address_line_3, length: { maximum: 50 }
  validates :town, presence: true, length: { maximum: 50 }
  validates :county, length: { maximum: 50 }
  validates :postcode, presence: true, postcode: true, if: :uk_address?
  validates :country, presence: true, inclusion: { in: Countries.all }

  validates :has_defined_contribution_pension,
            presence: true,
            inclusion: {
              in: %w(yes no unknown),
              allow_blank: true,
              message: '%{value} is not a valid value'
            }

  validates :format_preference, inclusion: { in: %w(standard large_text braille) }
  validates :appointment_type, inclusion: { in: %w(standard 50_54) }
  validates :number_of_previous_appointments, inclusion: { in: 0..3 }
  validates :email, format: EMAIL_REGEXP

  before_save :reset_notification_id!

  def self.editable_column_names
    column_names - %w(id created_at updated_at user_id notification_id)
  end

  def format_preference
    super || 'standard'
  end

  def appointment_type
    super || 'standard'
  end

  def eligible_for_guidance?
    %w(yes unknown).include?(has_defined_contribution_pension)
  end

  def can_be_emailed?
    requested_digital? && email.present?
  end

  private

  def uk_address?
    Countries.uk?(country)
  end

  def reset_notification_id!
    self.notification_id = '' if email_changed?
  end
end
