source 'https://rubygems.org'

ruby '2.2.1'

gem 'autoprefixer-rails'
gem 'bugsnag'
gem 'devise'
gem 'devise_invitable'
gem 'faraday'
gem 'foreman'
gem 'gaffe'
gem 'govuk_admin_template', '~> 1.0.0'
gem 'jc-validates_timeliness'
gem 'meta-tags'
gem 'newrelic_rpm'
gem 'pg'
gem 'puma'
gem 'rails', '4.2.0'
gem 'rails-i18n', '~> 4.0.0'
gem 'sass-rails', '~> 5.0'
gem 'sidekiq'
gem 'sinatra', require: nil # Sidekiq UI
gem 'uglifier', '>= 1.3.0'

group :development, :test do
  gem 'byebug'
  gem 'rspec-rails'
  gem 'scss-lint'
  gem 'web-console', '~> 2.0'
end

group :development do
  gem 'rubocop', require: false
  gem 'spring'
  gem 'spring-commands-cucumber'
  gem 'spring-commands-rspec'
end

group :test do
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'site_prism'
end

group :staging, :production do
  gem 'rails_12factor'
end
