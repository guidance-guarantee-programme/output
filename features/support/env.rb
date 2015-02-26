require 'capybara'
require 'capybara/cucumber'
require 'cucumber/rails'
require 'site_prism'

ActionController::Base.allow_rescue = false
DatabaseCleaner.strategy = :transaction

Cucumber::Rails::Database.javascript_strategy = :truncation
