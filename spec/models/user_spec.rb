require 'rails_helper'

RSpec.describe User, type: :model do
  subject { described_class.new }

  it { is_expected.to have_many(:appointment_summaries) }
end
