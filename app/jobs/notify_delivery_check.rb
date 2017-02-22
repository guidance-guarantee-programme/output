class NotifyDeliveryCheck < ActiveJob::Base
  queue_as :default

  def perform(appointment_summary)
    NotifyDelivery.new.call(appointment_summary)
  end
end
