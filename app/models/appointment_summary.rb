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

  TITLES = [
    'Mr', 'Mrs', 'Miss', 'Ms', 'Mx', 'Dr', 'Professor', 'Admiral', 'Sir', 'Lady', 'Dame',
    'Admiral Sir', 'Air Chief Marshal', 'Air Commodore', 'Air Vice Marshal', 'The Duchess of ',
    'General', 'General Sir', 'Group Captain', 'Lieutenant General', 'The Reverend',
    'Squadron Leader', 'The Viscount', 'The Viscountess', 'Lt Commander', 'Major The Hon',
    'Captain Viscount', 'The Rt Hon', 'Lt', 'Captain The Hon Sir', 'Prince',
    'Captain The Jonkheer', 'Viscount', 'Viscountess', 'The Hon Lady', 'Hon Mrs', 'Hon',
    'Countess', 'Earl', 'Lord', 'Commodore', 'Air Marshal', 'Flight Lieutenant', 'The Lord',
    'The Lady', 'Baron', 'The Baroness', 'Brigadier', 'Captain', 'Commander', 'Count', 'The Hon',
    'The Hon Mrs', 'Colonel', 'Major', 'Major General', 'His Honour Judge', 'Lt Colonel',
    'Rear Admiral', 'Wing Commander', 'Vice Admiral'
  ]

  belongs_to :user

  validates :title, presence: true, inclusion: { in: TITLES }
  validates :last_name, presence: true
  validates :date_of_appointment, timeliness: { on_or_before: -> { Date.current },
                                                on_or_after: Date.new(2015),
                                                type: :date }
  validates :reference_number, numericality: true, presence: true
  validates :value_of_pension_pots, presence: true
  validates :income_in_retirement, inclusion: { in: %w(pension other) }
  validates :guider_name, presence: true
  validates :guider_organisation, inclusion: { in: %w(tpas dwp) }

  validates :address_line_1, presence: true
  validates :town, presence: true
  validates :postcode, presence: true, postcode: true

  validates :has_defined_contribution_pension, inclusion: { in: %w(yes no unknown) }
  validates :format_preference, inclusion: { in: %w(standard large_text braille) }
end
