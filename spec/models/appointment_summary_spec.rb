require 'rails_helper'

RSpec.describe AppointmentSummary, type: :model do
  subject { described_class.new }

  it { is_expected.to validate_presence_of(:name) }

  it { is_expected.to allow_value('joe.bloggs@example.com').for(:email_address) }
  it { is_expected.to_not allow_value('joe @ example.com').for(:email_address) }

  it { is_expected.to allow_value('2015-02-10').for(:date_of_appointment) }
  it { is_expected.to allow_value('12/02/2015').for(:date_of_appointment) }
  it { is_expected.to_not allow_value('10/02/2012').for(:date_of_appointment) }
  it { is_expected.to_not allow_value(Date.tomorrow.to_s).for(:date_of_appointment) }

  it { is_expected.to validate_presence_of(:value_of_pension_pots) }

  it { is_expected.to validate_inclusion_of(:income_in_retirement).in_array(%w(pension other)) }

  it { is_expected.to validate_presence_of(:guider_name) }
  it { is_expected.to validate_inclusion_of(:guider_organisation).in_array(%w(tpas cab)) }
end
