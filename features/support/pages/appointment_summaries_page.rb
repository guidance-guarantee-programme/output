# frozen_string_literal: true

class AppointmentSummariesPage < SitePrism::Page
  set_url '/appointment_summaries'

  sections :appointments, '.t-appointment' do
    element :reference_number, '.t-reference-number'
    element :regenerate_button, '.t-regenerate'
  end

  element :search_input, '.t-search'
  element :search_button, '.t-search-button'

  def search(reference_number)
    search_input.set(reference_number)
    search_button.click
  end
end
