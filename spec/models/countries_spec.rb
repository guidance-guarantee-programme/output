require 'spec_helper'
require_relative File.join(File.dirname(__FILE__), '..', '..', 'app', 'models', 'countries')

RSpec.describe Countries do
  describe '.all' do
    subject { Countries.all }

    it { is_expected.not_to be_empty }
  end

  describe '.uk' do
    subject { Countries.uk }

    it { is_expected.to eq 'United Kingdom' }
    it 'is in the "all countries" list' do
      expect(Countries.all).to include(Countries.uk)
    end
  end

  describe '.non_uk' do
    subject { Countries.non_uk }

    it { is_expected.not_to include(Countries.uk) }
    it 'contains all other countries' do
      expect(Countries.non_uk + [Countries.uk]).to match_array(Countries.all)
    end
  end
end
