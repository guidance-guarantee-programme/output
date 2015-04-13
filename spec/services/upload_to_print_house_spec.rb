require 'rails_helper'

RSpec.describe UploadToPrintHouse, '#call' do
  let(:csv) { 'c,s,v' }

  subject { described_class.new(csv).call }

  it { is_expected.to be_nil }
end
