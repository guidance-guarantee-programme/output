require 'rails_helper'

RSpec.describe 'GET /api/v1/appointment_summaries/{reference}.json' do
  scenario 'retrieving a TAP digital summary' do
    given_an_api_user do
      and_multiple_summaries_for_a_given_reference_exist
      when_a_request_for_the_given_reference_is_made
      then_the_service_responds_ok
      and_the_correct_summary_email_is_serialized_in_the_response
    end
  end

  scenario 'retrieving a missing TAP digital summary' do
    given_an_api_user do
      when_a_request_for_a_missing_tap_digital_summary_is_made
      the_service_responds_404
    end
  end

  scenario 'unauthorized access' do
    given_a_user do
      when_an_unauthorized_request_is_made
      then_the_service_responds_with_a_403_status
    end
  end

  def and_multiple_summaries_for_a_given_reference_exist
    create(:appointment_summary, :requested_digital, reference_number: '123', email: 'bob@example.com')
    # the last summary created for the reference '123'
    create(:appointment_summary, :requested_digital, reference_number: '123', email: 'ben@example.com')
  end

  def when_a_request_for_the_given_reference_is_made
    get api_v1_appointment_summary_path(id: '123'), as: :json
  end

  def then_the_service_responds_ok
    expect(response).to be_ok
  end

  def and_the_correct_summary_email_is_serialized_in_the_response
    expect(response.body).to eq('{"email":"ben@example.com"}')
  end

  def when_a_request_for_a_missing_tap_digital_summary_is_made
    get api_v1_appointment_summary_path(id: '666'), as: :json
  end

  def the_service_responds_404
    expect(response).to be_missing
  end

  def when_an_unauthorized_request_is_made
    get api_v1_appointment_summary_path(id: '666'), as: :json
  end

  def then_the_service_responds_with_a_403_status
    expect(response).to be_forbidden
  end
end
