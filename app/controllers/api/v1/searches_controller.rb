module Api
  module V1
    class SearchesController < ActionController::Base
      include GDS::SSO::ControllerMethods

      before_action { authorise_user!(User::API_USER_PERMISSION) }

      def index
        @results = AppointmentSummarySearch.new(params[:query]).call

        render json: @results
      end
    end
  end
end
