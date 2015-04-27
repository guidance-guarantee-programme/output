require 'rails_helper'

RSpec.describe Batch, type: :model do
  it { is_expected.to have_many(:appointment_summaries).through(:appointment_summaries_batches) }
  it { is_expected.to have_many(:appointment_summaries_batches).dependent(:destroy) }

  let(:batch) { described_class.new }

  describe '#uploaded_at' do
    subject { batch.uploaded_at }

    it { is_expected.to be_nil }
  end
end
