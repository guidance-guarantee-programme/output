require 'capybara'
require 'capybara/cucumber'
require 'cucumber/rails'
require 'cucumber/rspec/doubles'
require 'site_prism'

ActionController::Base.allow_rescue = false
DatabaseCleaner.strategy = :transaction

Cucumber::Rails::Database.javascript_strategy = :truncation
