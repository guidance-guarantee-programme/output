require 'rails_helper'

RSpec.describe NotifyDeliveryChecker do
  include ActiveJob::TestHelper

  before do
    # due for checking
    @due = create(:notify_delivered_appointment_summary)
    # already marked completed
    create(:notify_delivered_appointment_summary, notify_completed_at: Time.zone.now)
    # outside the two day window
    create(:notify_delivered_appointment_summary, created_at: 3.days.ago)
    # without a notification ID from the notify service
    create(:notify_delivered_appointment_summary, notification_id: '')
  end

  it 'schedules the correct summaries for checking' do
    assert_enqueued_with job: NotifyDeliveryCheck, args: Array(@due) do
      NotifyDeliveryChecker.new.call
    end
  end
end
