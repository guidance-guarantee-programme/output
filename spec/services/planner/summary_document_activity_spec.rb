require 'rails_helper'

RSpec.describe Planner::SummaryDocumentActivity, '#save' do
  it 'delegates to the API' do
    api = instance_double(Planner::Api, create_summary_document_activity: true)

    subject = described_class.new(
      booking_request_id: 1,
      owner_uid: 'deadbeef',
      delivery_method: 'digital',
      api: api
    )

    subject.save

    expect(api).to have_received(:create_summary_document_activity).with(
      booking_request_id: 1,
      owner_uid: 'deadbeef',
      delivery_method: 'digital'
    )
  end
end
