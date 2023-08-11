require 'webdrivers/chromedriver'
require 'selenium/webdriver'

Capybara.register_driver :chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new(args: %w(headless no-sandbox))

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Webdrivers::Chromedriver.required_version = '114.0.5735.90'
Webdrivers.install_dir = '/opt/homebrew/bin' unless ENV['TRAVIS']

Capybara.default_max_wait_time = 10 if ENV['TRAVIS']
Capybara.server = :puma, { Silent: true }
Capybara.javascript_driver = :chrome
