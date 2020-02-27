require_relative 'boot'

require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'sprockets/railtie'

Bundler.require(*Rails.groups)

module Output
  class Application < Rails::Application
    config.action_mailer.default_url_options = { host: ENV['APPLICATION_HOST'] }
    config.active_job.queue_adapter = :sidekiq

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '/api/v1/searches', headers: :any, methods: %i(get options)
      end
    end
  end
end
