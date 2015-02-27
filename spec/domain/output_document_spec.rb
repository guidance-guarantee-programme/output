require 'rails_helper'

RSpec.describe OutputDocument, '#content' do
  let(:appointment_summary) do
    AppointmentSummary.create(
      name: 'Joe Bloggs',
      email_address: 'a@b.com'
    )
  end
  let(:content) { described_class.new(appointment_summary).content }

  it 'renders a PDF' do
    expect { PDF::Inspector::Text.analyze(content) }.to_not raise_error
  end
end
