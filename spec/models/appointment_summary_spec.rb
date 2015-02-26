require 'rails_helper'

RSpec.describe AppointmentSummary, type: :model do
  subject { described_class.new }

  it { is_expected.to validate_presence_of(:name) }
end
