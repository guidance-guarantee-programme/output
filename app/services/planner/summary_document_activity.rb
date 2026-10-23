module Planner
  class SummaryDocumentActivity
    def initialize(booking_request_id:, owner_uid:, delivery_method:, api: Planner::Api.new)
      @booking_request_id = booking_request_id
      @owner_uid = owner_uid
      @delivery_method = delivery_method
      @api = api
    end

    def save
      api.create_summary_document_activity(
        booking_request_id: booking_request_id,
        owner_uid: owner_uid,
        delivery_method: delivery_method
      )
    end

    private

    attr_reader :booking_request_id, :owner_uid, :delivery_method, :api
  end
end
