require 'rails_helper'

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

  describe '.uk?' do
    specify { expect(Countries.uk?(Countries.uk)).to be_truthy }
    specify { expect(Countries.uk?(Countries.non_uk.sample)).to be_falsey }
    specify { expect(Countries.uk?('nonsense')).to be_falsey }
    specify { expect(Countries.uk?('')).to be_falsey }
    specify { expect(Countries.uk?(nil)).to be_falsey }
  end
end
