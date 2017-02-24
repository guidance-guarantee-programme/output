class NotifyDeliveriesCheck < ActiveJob::Base
  queue_as :default

  def perform
    NotifyDeliveryChecker.new.call
  end
end
