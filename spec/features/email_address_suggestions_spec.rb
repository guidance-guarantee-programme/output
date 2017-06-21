require 'rails_helper'
require 'timeout'

RSpec.feature 'Mailgun email verification service suggestions', js: true do
  scenario 'Mailgun says the email address is invalid' do
    given_i_am_logged_in_as_a_face_to_face_guider
    and_i_am_on_the_summary_form
    with_mock_invalid_mailgun_response do
      when_i_enter_an_invalid_email_address
      and_change_focus
      then_i_should_see_be_warned_of_the_invalid_address
    end
  end

  scenario 'Mailgun has a suggestion on the email address' do
    given_i_am_logged_in_as_a_face_to_face_guider
    and_i_am_on_the_summary_form
    with_mock_suggested_mailgun_response do
      when_i_enter_an_email_address_with_a_suggestion
      and_change_focus
      then_i_should_see_a_correction_suggestion
      and_if_i_click_the_suggestion
      then_it_should_update_the_email_address_with_the_suggestion
    end
  end

  def given_i_am_logged_in_as_a_face_to_face_guider
    create(:user)
  end

  def and_i_am_on_the_summary_form
    @page = AppointmentSummaryPage.new
    @page.load
  end

  def with_mock_invalid_mailgun_response(&block)
    response = {
      is_valid: false,
      address: 'something@totallyinvalid',
      parts: {
        display_name: nil,
        local_part: 'something',
        domain: 'totallyinvalid'
      },
      did_you_mean: nil
    }

    with_mock_mailgun_response(response, block)
  end

  def with_mock_suggested_mailgun_response(&block)
    response = {
      is_valid: false,
      address: 'joe.bloggs@gmall.com',
      parts: {
        display_name: nil,
        local_part: 'joe.bloggs',
        domain: 'gmall.com'
      },
      did_you_mean: 'joe.bloggs@gmail.com'
    }

    with_mock_mailgun_response(response, block)
  end

  def when_i_enter_an_email_address_with_a_suggestion
    @page.email.set 'joe.bloggs@gmall.com'
  end

  def when_i_enter_an_invalid_email_address
    @page.email.set 'something@totallyinvalid'
  end

  def and_change_focus
    @page.first_name.click
  end

  def then_i_should_see_be_warned_of_the_invalid_address
    expect(@page).to have_content("That doesn't look like a valid address")
  end

  def then_i_should_see_a_correction_suggestion
    expect(@page.email_suggestion).to have_content('joe.bloggs@gmail.com')
  end

  before(:all) do
    @server = WEBrick::HTTPServer.new(
      Port: 9293,
      StartCallback: -> { @running = true },
      Logger: Rails.logger,
      AccessLog: Rails.logger
    )

    @thread = Thread.new { @server.start }
    Timeout.timeout(1) { :wait until @running }
  end

  after(:all) do
    @server.shutdown
    @thread.kill
  end

  def with_mock_mailgun_response(response, block)
    @server.mount '/v2/address/validate', Rack::Handler::WEBrick, lambda { |env|
      req = Rack::Request.new(env)
      response_body = "#{req.params['callback']}(#{response.to_json})"

      [200, {}, [response_body]]
    }

    block.call
  end

  def and_if_i_click_the_suggestion
    @suggested_email = @page.email_suggestion.text
    @page.email_suggestion.click
  end

  def then_it_should_update_the_email_address_with_the_suggestion
    expect(@page.email.value).to eq @suggested_email
  end
end
