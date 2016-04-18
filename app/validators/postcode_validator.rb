# frozen_string_literal: true
class PostcodeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    valid_postcode = UKPostcode.parse(value).full_valid?

    record.errors.add(attribute, 'is not a postcode') unless valid_postcode
  end
end
