module Planner
  class DroppedSummaryDocumentActivity
    def initialize(booking_request_id, api: Planner::Api.new)
      @booking_request_id = booking_request_id
      @api = api
    end

    def save
      api.create_dropped_summary_document_activity(booking_request_id)
    end

    private

    attr_reader :booking_request_id, :api
  end
end
