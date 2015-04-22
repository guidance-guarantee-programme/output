require 'json'
require 'uri'

class AppointmentSummary < ActiveRecord::Base
  scope :unprocessed, lambda {
    includes(:appointment_summaries_batches)
      .where(appointment_summaries_batches: { appointment_summary_id: nil })
  }

  PostcodeValidator = Class.new(ActiveModel::EachValidator) do
    def validate_each(record, attribute, value)
      return if value.blank?

      result = Faraday.get("https://api.postcodes.io/postcodes/#{URI.escape(value)}/validate")
      valid_postcode = result.success? && JSON.parse(result.body)['result']

      record.errors.add(attribute, 'is not a postcode') unless valid_postcode
    end
  end

  def postcode=(str)
    if str.blank?
      super
    else
      super str.upcase.strip
    end
  end

  TITLES = %w(Mr Mrs Miss Ms Mx Dr)

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
  validates :country, inclusion: { in: Countries.all, allow_blank: true, allow_nil: true }
  validates :postcode, presence: true, postcode: true

  validates :has_defined_contribution_pension,
            presence: true,
            inclusion: {
              in: %w(yes no unknown),
              allow_blank: true,
              message: '%{value} is not a valid value'
            }

  validates :format_preference, inclusion: { in: %w(standard large_text braille) }

  def format_preference
    super || 'standard'
  end

  def eligible_for_guidance?
    %w(yes unknown).include?(has_defined_contribution_pension)
  end

  def generic_guidance?
    eligible_for_guidance? && !retirement_circumstances?
  end

  def custom_guidance?
    eligible_for_guidance? && retirement_circumstances?
  end

  private

  # rubocop:disable CyclomaticComplexity
  def retirement_circumstances?
    continue_working? || unsure? || leave_inheritance? || \
      wants_flexibility? || wants_security? || wants_lump_sum? || \
      poor_health?
  end
  # rubocop:enable CyclomaticComplexity
end
