require 'rails_helper'

RSpec.describe Batch, type: :model do
  it { is_expected.to have_many(:appointment_summaries).through(:appointment_summaries_batches) }
  it { is_expected.to have_many(:appointment_summaries_batches).dependent(:destroy) }
end
