require 'rails_helper'

RSpec.describe NotifyDeliveryCheck, '#perform' do
  let(:appointment_summary) { double }
  let(:service) { instance_double(NotifyDelivery) }

  it 'calls the service with the given appointment summary' do
    expect(NotifyDelivery).to receive(:new) { service }
    expect(service).to receive(:call).with(appointment_summary)

    described_class.new.perform(appointment_summary)
  end
end
