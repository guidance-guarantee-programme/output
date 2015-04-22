require 'rails_helper'

RSpec.describe CountriesHelper, type: :helper do
  describe '#prioritised_country_list' do
    subject(:prioritised_country_list) { helper.prioritised_country_list }

    it 'returns the entire country list' do
      expect(prioritised_country_list).to match_array(Countries.all)
    end

    it 'returns "United Kingdom" first' do
      expect(prioritised_country_list.first).to eq(Countries.uk)
    end
  end
end
