require 'rails_helper'

RSpec.describe Admin::AppointmentSummariesController, type: :controller do
  let(:email) { 'guider@example.com' }
  let(:password) { 'pensionwise' }
  let(:user) { User.create(email: email, password: password, role: 'admin').tap(&:confirm!) }
  let(:appointment_summary) { create(:appointment_summary, notification_id: '123', requested_digital: true) }

  describe '#update' do
    subject { response }

    context 'when not authenticated' do
      before do
        put :update, id: appointment_summary.id
      end

      it { is_expected.to redirect_to(controller: 'devise/sessions', action: :new) }
    end

    context 'when authenticated' do
      before do
        allow(NotifyViaEmail).to receive(:perform_later)
        sign_in user
        put :update, id: appointment_summary.id, appointment_summary: { email: email }
        appointment_summary.reload
      end

      context 'when email has changed and is valid' do
        let(:email) { 'good-email@test.com' }

        it 'updates the email address' do
          expect(appointment_summary.email).to eq(email)
        end

        it 'resets the notification_id' do
          expect(appointment_summary.notification_id).to be_blank
        end

        it 'enqueues the NotifyViaEmail job' do
          expect(NotifyViaEmail).to have_received(:perform_later).with(appointment_summary)
        end

        context 'when the customer has not requested a digital summary document' do
          let(:appointment_summary) { create(:appointment_summary, notification_id: '123', requested_digital: false) }

          it 'does not enqueue the NotifyViaEmail job' do
            expect(NotifyViaEmail).not_to have_received(:perform_later)
          end
        end
      end

      context 'when email has not changed' do
        let(:email) { appointment_summary.email }

        it 'resets the notification_id' do
          expect(appointment_summary.notification_id).to be_blank
        end

        it 'enqueues the NotifyViaEmail job' do
          expect(NotifyViaEmail).to have_received(:perform_later).with(appointment_summary)
        end
      end

      context 'when email is not valid' do
        let(:email) { 'bad email@test.com' }

        it 'does not resets the notification_id' do
          expect(appointment_summary.notification_id).not_to be_blank
        end

        it 'does not enqueue the NotifyViaEmail job' do
          expect(NotifyViaEmail).not_to have_received(:perform_later)
        end
      end
    end
  end
end
