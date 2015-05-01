require 'site_prism'
require_relative './radio_button_group'

module SitePrism
  module RadioButtonContainer
    def radio_buttons(group_name, values_to_find_args)
      values_to_names = Hash[
        values_to_find_args.keys.map { |value| [value, :"#{group_name}_#{value}"] }
      ]

      values_to_find_args.each do |value, find_args|
        element values_to_names[value], *find_args
      end

      define_method group_name.to_s do
        RadioButtonGroup.new(self, values_to_names.invert)
      end
    end
  end
end
