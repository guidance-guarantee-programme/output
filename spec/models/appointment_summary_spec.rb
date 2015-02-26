require 'rails_helper'

RSpec.describe AppointmentSummary, type: :model do
  subject { described_class.new }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to allow_value('joe.bloggs@example.com').for(:email_address) }
  it { is_expected.to_not allow_value('joe @ example.com').for(:email_address) }
end
