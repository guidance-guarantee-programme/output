ENV['RAILS_ENV'] ||= 'test'

require 'spec_helper'
require_relative '../config/environment'
require 'rspec/rails'
require 'database_rewinder'

require_relative '../features/support/pages/done_page'
require_relative '../features/support/pages/confirmation_page'
require_relative '../features/support/pages/appointment_summary_page'
require_relative '../features/support/pages/appointment_summary_browser_page'
require_relative '../features/support/pages/appointment_summary_edit_page'

ActiveRecord::Migration.maintain_test_schema!
Dir[File.join(File.dirname(__FILE__), 'support', '**', '*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include UserHelpers

  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.infer_spec_type_from_file_location!
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
