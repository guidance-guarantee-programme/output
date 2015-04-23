require 'rails_helper'

RSpec.describe PostcodeValidator, type: :model do
  let(:klass) do
    Class.new do
      include ActiveModel::Validations

      attr_accessor :postcode

      validates :postcode, postcode: true
    end
  end

  subject { klass.new }

  it { is_expected.to allow_value('SW1A 2HQ').for(:postcode) }
  it { is_expected.to allow_value('SW1A2HQ').for(:postcode) }
  it { is_expected.to_not allow_value('SW1A2H').for(:postcode) }
  it { is_expected.to_not allow_value('SWIA2HQ').for(:postcode) }
end
