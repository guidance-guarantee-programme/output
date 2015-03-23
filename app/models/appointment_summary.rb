require 'json'
require 'uri'

class AppointmentSummary < ActiveRecord::Base
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

  validates :title, presence: true, inclusion: { in: TITLES }
  validates :last_name, presence: true
  validates :date_of_appointment, timeliness: { on_or_before: -> { Date.current },
                                                on_or_after: Date.new(2015),
                                                type: :date }
  validates :reference_number, numericality: true, presence: true

  with_options numericality: true, allow_blank: true, if: :eligible_for_guidance? do |eligible|
    eligible.validates :value_of_pension_pots
    eligible.validates :upper_value_of_pension_pots
  end

  validates :income_in_retirement, inclusion: { in: %w(pension other) }, if: :eligible_for_guidance?
  validates :guider_name, presence: true
  validates :guider_organisation, inclusion: { in: %w(tpas dwp) }

  validates :address_line_1, presence: true
  validates :town, presence: true
  validates :postcode, presence: true, postcode: true

  validates :has_defined_contribution_pension, inclusion: { in: %w(yes no unknown) }
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
