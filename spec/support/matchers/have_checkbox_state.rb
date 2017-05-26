# frozen_string_literal: true
require 'rspec/expectations'

module CheckedState
  RSpec::Matchers.define :have_checked_state do |expected_check_state|
    match do |element|
      !!element.checked? == !!expected_check_state
    end
  end
end
