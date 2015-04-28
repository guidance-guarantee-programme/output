require 'rails_helper'

RSpec.describe Batch, type: :model do
  it { is_expected.to have_many(:appointment_summaries).through(:appointment_summaries_batches) }
  it { is_expected.to have_many(:appointment_summaries_batches).dependent(:destroy) }

  it 'has a default #uploaded_at of nil' do
    expect(subject.uploaded_at).to be_nil
  end

  describe '#mark_as_uploaded' do
    it 'sets uploaded_at to now and saves the record' do
      batch = Batch.create

      batch.mark_as_uploaded
      batch.reload

      expect(batch.uploaded_at).to be_within(0.1.seconds).of Time.zone.now
    end
  end
end
