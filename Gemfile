ruby IO.read('.ruby-version').strip

# force Bundler to use HTTPS for github repos
git_source(:github) { |repo_name| "https://github.com/#{repo_name}.git" }

source 'https://rubygems.org' do # rubocop:disable Metrics/BlockLength
  gem 'active_model_serializers'
  gem 'autoprefixer-rails'
  gem 'azure-storage-blob'
  gem 'bootsnap', require: false
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
  gem 'notifications-ruby-client'
  gem 'output-templates', '~> 4.9', github: 'guidance-guarantee-programme/output-templates'
  gem 'pg', '0.21.0'
  gem 'plek'
  gem 'postgres-copy'
  gem 'princely'
  gem 'puma'
  gem 'rack-cors'
  gem 'rails', '~> 5.1.6'
  gem 'rails-i18n', '~> 5.0.0'
  gem 'retriable'
  gem 'sassc-rails'
  gem 'sidekiq'
  gem 'sinatra', require: nil # Sidekiq UI
  gem 'telephone_appointments'
  gem 'uglifier', '>= 1.3.0'
  gem 'uk_postcode'

  group :development, :test do
    gem 'database_rewinder'
    gem 'launchy'
    gem 'phantomjs'
    gem 'poltergeist'
    gem 'pry-byebug'
    gem 'rspec-rails'
    gem 'scss_lint', require: false
  end

  group :development do
    gem 'rubocop', '0.47.1', require: false
    gem 'web-console', '~> 2.0'
  end

  group :test do
    gem 'shoulda-matchers'
    gem 'site_prism'
    gem 'webrick'
  end

  gem 'factory_bot_rails', group: %i(development test)

  group :staging, :production do
    gem 'rails_12factor'
  end
end
