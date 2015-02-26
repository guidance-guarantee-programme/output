source 'https://rubygems.org'

gem 'bugsnag'
gem 'coffee-rails', '~> 4.1.0'
gem 'foreman'
gem 'gaffe'
gem 'meta-tags'
gem 'newrelic_rpm'
gem 'pg'
gem 'puma'
gem 'rails', '4.2.0'
gem 'sass-rails', '~> 5.0'
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
end

group :staging, :production do
  gem 'rails_12factor'
end
