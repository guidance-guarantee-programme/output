require 'webdrivers/chromedriver'
require 'selenium/webdriver'

Capybara.register_driver :chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new(args: %w(headless no-sandbox))

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara.default_max_wait_time = 10 if ENV['TRAVIS']
Capybara.server = :puma, { Silent: true }
Capybara.javascript_driver = :chrome
