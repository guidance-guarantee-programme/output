require 'capybara/poltergeist'

# Force installation when necessary
Phantomjs.path

Capybara.javascript_driver = :poltergeist
Capybara.default_max_wait_time = 10 if ENV['TRAVIS']
