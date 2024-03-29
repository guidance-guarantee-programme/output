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

      def update
        @appointment_summary = AppointmentSummary.for_tap_reissue(params[:id])

        if @appointment_summary.update(email: params[:email])
          @appointment_summary.notify_via_email
          CreateTapActivity.perform_later(@appointment_summary, params[:initiator_uid])

          head :ok
        else
          head :unprocessable_entity
        end
      end
    end
  end
end
