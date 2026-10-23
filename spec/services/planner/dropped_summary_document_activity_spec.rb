require 'rails_helper'

RSpec.describe Planner::DroppedSummaryDocumentActivity, '#save' do
  it 'delegates to the API' do
    api = instance_double(Planner::Api, create_dropped_summary_document_activity: true)

    subject = described_class.new(1, api: api)
    subject.save

    expect(api).to have_received(:create_dropped_summary_document_activity).with(1)
  end
end
