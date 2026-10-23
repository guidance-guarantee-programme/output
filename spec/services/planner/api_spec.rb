require 'rails_helper'

RSpec.describe Planner::Api, vcr: true do
  describe '#create_summary_document_activity' do
    context 'when successful' do
      it 'returns true' do
        result = described_class.new.create_summary_document_activity(
          booking_request_id: 9,
          owner_uid: '33f81237-eeb1-43ac-93dd-eb42cf23a86c',
          delivery_method: 'digital'
        )

        expect(result).to be true
      end
    end
  end
end
