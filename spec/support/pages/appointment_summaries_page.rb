# frozen_string_literal: true

class AppointmentSummariesPage < SitePrism::Page
  set_url '/appointment_summaries'

  sections :appointments, '.t-appointment' do
    element :reference_number, '.t-reference-number'
    element :reprint_button, '.t-reprint'
  end

  element :search_input, '.t-search'
  element :search_button, '.t-search-button'

  element :search_date_input, '.t-date-search'
  element :search_date_button, '.t-date-search-button'

  def search(reference_number)
    search_input.set(reference_number)
    search_button.click
  end

  def search_date(date)
    search_date_input.set(date.strftime('%d/%m/%Y'))
    search_date_button.click
  end
end
