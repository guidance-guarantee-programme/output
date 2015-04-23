class PostcodeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    result = Faraday.get("https://api.postcodes.io/postcodes/#{URI.escape(value)}/validate")
    valid_postcode = result.success? && JSON.parse(result.body)['result']

    record.errors.add(attribute, 'is not a postcode') unless valid_postcode
  end
end
