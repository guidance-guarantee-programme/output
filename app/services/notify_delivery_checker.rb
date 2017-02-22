class NotifyDeliveryChecker
  def call
    AppointmentSummary.needing_notify_delivery_check.each do |as|
      NotifyDeliveryCheck.perform_later(as)
    end
  end
end
