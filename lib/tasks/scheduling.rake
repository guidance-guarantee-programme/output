namespace :scheduling do
  desc 'Schedule a job every minute in the next ten minutes'
  task notify_checks: :environment do
    NotifyDeliveriesCheck.perform_later

    (1..9).each do |n|
      NotifyDeliveriesCheck.set(wait_until: n.minutes.from_now).perform_later
    end
  end
end
