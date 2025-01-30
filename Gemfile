ruby IO.read('.ruby-version').strip

source 'https://rubygems.org'

# force Bundler to use HTTPS for github repos
git_source(:github) { |repo_name| "https://github.com/#{repo_name}.git" }

source 'https://rubygems.org' do # rubocop:disable Metrics/BlockLength
  gem 'active_model_serializers'
  gem 'autoprefixer-rails'
  gem 'azure-storage-blob', '~> 2.0.3'
  gem 'bootsnap', require: false
  gem 'bootstrap-kaminari-views'
  gem 'bugsnag'
  gem 'deprecated_columns'
  gem 'faraday'
  gem 'ffi', '~> 1.15.0'
  gem 'foreman'
  gem 'gaffe'
  gem 'gds-sso'
  gem 'govuk_admin_template'
  gem 'kaminari'
  gem 'meta-tags', '~> 2.22'
  gem 'net-http'
  gem 'net-sftp'
  gem 'notifications-ruby-client'
  gem 'output-templates', github: 'guidance-guarantee-programme/output-templates', ref: 'ed76f62'
  gem 'pg'
  gem 'plek'
  gem 'postgres-copy'
  gem 'princely'
  gem 'puma'
  gem 'rack-cors'
  gem 'rails', '~> 8.0.1'
  gem 'rails-i18n'
  gem 'retriable'
  gem 'sassc-rails'
  gem 'sidekiq', '~> 7.3.8'
  gem 'sinatra', require: nil # Sidekiq UI
  gem 'sprockets', '~> 4.2.1'
  gem 'telephone_appointments',
      github: 'guidance-guarantee-programme/telephone_appointments',
      branch: 'relax-dependencies'
  gem 'uglifier', '>= 1.3.0'
  gem 'uk_postcode'
  gem 'validates_timeliness'

  group :development, :test do
    gem 'database_rewinder'
    gem 'launchy'
    gem 'pry-byebug'
    gem 'rspec-rails'
    gem 'rubocop', require: false
    gem 'rubocop-rails', require: false
    gem 'scss_lint', require: false
    gem 'selenium-webdriver'
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
