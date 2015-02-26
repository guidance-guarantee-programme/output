require 'cucumber/rails'

ActionController::Base.allow_rescue = false
DatabaseCleaner.strategy = :transaction

Cucumber::Rails::Database.javascript_strategy = :truncation
