require 'rails_helper'

RSpec.describe Batch, type: :model do
  it { is_expected.to have_many(:appointment_summaries).through(:appointment_summaries_batches) }
  it { is_expected.to have_many(:appointment_summaries_batches).dependent(:destroy) }

  let(:batch) { described_class.new }

  describe '#uploaded_at' do
    subject { batch.uploaded_at }

    it { is_expected.to be_nil }
  end

  describe '#mark_as_uploaded' do
    before { batch.mark_as_uploaded }

    it 'saves uploaded_at as now' do
      expect(batch.reload.uploaded_at).to be_within(0.1.seconds).of Time.zone.now
    end
  end
end
