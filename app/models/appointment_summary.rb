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

  belongs_to :user

  validates :name, presence: true
  validates :email_address, format: RFC822::EMAIL, allow_blank: true
  validates :date_of_appointment, timeliness: { on_or_before: -> { Date.current },
                                                on_or_after: Date.new(2015),
                                                type: :date }
  validates :value_of_pension_pots, presence: true
  validates :income_in_retirement, inclusion: { in: %w(pension other) }
  validates :guider_name, presence: true
  validates :guider_organisation, inclusion: { in: %w(tpas cab dwp) }

  validates :address_line_1, presence: true
  validates :town, presence: true
  validates :postcode, presence: true, postcode: true
end
