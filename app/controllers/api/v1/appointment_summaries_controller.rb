module Api
  module V1
    class AppointmentSummariesController < ActionController::Base
      include GDS::SSO::ControllerMethods

      before_action { authorise_user!(User::API_USER_PERMISSION) }

      def show
        @appointment_summary = AppointmentSummary.for_tap_reissue(params[:id])

        if @appointment_summary
          render json: @appointment_summary.to_json(only: [:email])
        else
          head :not_found
        end
      end
    end
  end
end
