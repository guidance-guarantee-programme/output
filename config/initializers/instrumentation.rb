ActiveSupport::Notifications.subscribe(/log/) do |name, start, finish, id, payload|
  component = name.split('.').first
  Rails.logger.tagged(component) { |logger| logger.info(payload) }
end
