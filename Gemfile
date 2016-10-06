# frozen_string_literal: true
source 'https://rubygems.org'

ruby IO.read('.ruby-version').strip

# force Bundler to use HTTPS for github repos
git_source(:github) { |repo_name| "https://github.com/#{repo_name}.git" }

gem 'autoprefixer-rails'
gem 'bootstrap-kaminari-views'
gem 'bugsnag'
gem 'deprecated_columns'
gem 'devise'
gem 'devise_invitable'
gem 'devise_zxcvbn'
gem 'faraday'
gem 'foreman'
gem 'gaffe'
gem 'govuk_admin_template'
gem 'jc-validates_timeliness'
gem 'kaminari'
gem 'meta-tags'
gem 'net-sftp'
gem 'newrelic_rpm'
gem 'notifications-ruby-client', github: 'alphagov/notifications-ruby-client'
gem 'output-templates', '~> 4.4.0', github: 'guidance-guarantee-programme/output-templates'
gem 'pg'
gem 'princely'
gem 'puma'
gem 'rails', '4.2.6'
gem 'rails-i18n', '~> 4.0.0'
gem 'retriable'
gem 'sass-rails', '~> 5.0'
gem 'sidekiq'
gem 'sinatra', require: nil # Sidekiq UI
gem 'uglifier', '>= 1.3.0'
gem 'uk_postcode'

group :development, :test do
  gem 'launchy'
  gem 'pry-byebug'
  gem 'rspec-rails'
  gem 'scss-lint'
  gem 'web-console', '~> 2.0'
end

group :development do
  gem 'rubocop', require: false
end

group :test do
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'site_prism'
end

gem 'factory_girl_rails', group: %i(development test)

group :staging, :production do
  gem 'rails_12factor'
end
