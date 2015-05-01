require 'site_prism'

module SitePrism
  class RadioButtonGroup
    attr_reader :page, :names_to_values
    private :names_to_values

    def initialize(page, names_to_values)
      @page = page
      @names_to_values = names_to_values.dup
    end

    def selected_value
      selected_values = find_selected_element_values

      if selected_values.one?
        selected_values.first.to_s
      elsif selected_values.any?
        fail 'Multiple options are selected (is something wrong with your markup?)'
      end
    end

    # rubocop:disable PredicateName
    def has_selected_value?(value)
      selected_value == value
    end
    # rubocop:enable PredicateName

    private

    def find_selected_element_values
      names_and_elements = element_names.map { |name| [name, find_element(name)] }

      names_and_elements
        .select { |_, element| element.checked? }
        .map { |name, _| names_to_values[name] }
    end

    def element_names
      names_to_values.keys
    end

    def find_element(name)
      page.public_send(name)
    end
  end
end
