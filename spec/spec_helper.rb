require 'retriable'

RSpec.configure do |config|
  config.default_formatter = 'doc' if config.files_to_run.one?
  config.disable_monkey_patching!
  config.filter_run :focus
  config.order = :random
  config.run_all_when_everything_filtered = true

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  Kernel.srand config.seed
end

Retriable.configure do |c|
  c.base_interval = 0
end
