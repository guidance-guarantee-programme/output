# frozen_string_literal: true
source 'https://rubygems.org'

ruby IO.read('.ruby-version').strip

# force Bundler to use HTTPS for github repos
git_source(:github) { |repo_name| "https://github.com/#{repo_name}.git" }

gem 'autoprefixer-rails'
gem 'bootstrap-kaminari-views'
gem 'bugsnag'
gem 'deprecated_columns'
gem 'faraday'
gem 'foreman'
gem 'gaffe'
gem 'gds-sso'
gem 'govuk_admin_template'
gem 'jc-validates_timeliness'
gem 'kaminari'
gem 'meta-tags'
gem 'net-sftp'
gem 'newrelic_rpm'
gem 'notifications-ruby-client', github: 'alphagov/notifications-ruby-client'
gem 'output-templates', '~> 4.4.4', github: 'guidance-guarantee-programme/output-templates'
gem 'pg'
gem 'plek'
gem 'princely', github: 'guidance-guarantee-programme/princely', branch: 'remove-alias-method-chain'
gem 'puma'
gem 'rails', '5.0.1'
gem 'rails-i18n', '~> 4.0.0'
gem 'retriable'
gem 'sass-rails', '~> 5.0'
gem 'sidekiq'
gem 'sinatra', require: nil # Sidekiq UI
gem 'telephone_appointments'
gem 'uglifier', '>= 1.3.0'
gem 'uk_postcode'

group :development, :test do
  gem 'launchy'
  gem 'pry-byebug'
  gem 'rspec-rails'
  gem 'scss-lint'
end

group :development do
  gem 'rubocop', require: false
  gem 'web-console', '~> 2.0'
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
