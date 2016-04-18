# frozen_string_literal: true
class TransliteratedAppointmentSummary < SimpleDelegator
  %i(first_name last_name guider_name
     address_line_1 address_line_2 address_line_3
     town county postcode country).each do |method_name|
    define_method(method_name) do
      I18n.transliterate(super())
    end
  end
end
