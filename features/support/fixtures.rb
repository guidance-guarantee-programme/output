# frozen_string_literal: true
module Fixtures
  def fixture(name)
    FIXTURES.fetch(name).call
  end

  FIXTURES = {
    populated_appointment_summary: proc do
      AppointmentSummary.new(
        title: 'Mr',
        first_name: 'Joé',
        last_name: 'Bløggs',
        address_line_1: 'HM Treasury',
        address_line_2: '1 Hôrse Guârds Roåd',
        address_line_3: 'Weštminstęr',
        town: 'London',
        county: 'Greater London',
        country: 'United Kingdom',
        postcode: 'SW1A 2HQ',
        appointment_type: 'standard',
        date_of_appointment: '2015-02-05',
        reference_number: 1245,
        value_of_pension_pots: 35_000,
        upper_value_of_pension_pots: 55_000,
        value_of_pension_pots_is_approximate: true,
        guider_name: 'Pênelopę',
        has_defined_contribution_pension: 'yes',
        continue_working: true,
        unsure: true,
        leave_inheritance: true,
        wants_flexibility: true,
        wants_security: true,
        wants_lump_sum: true,
        poor_health: true,
        format_preference: 'standard',
        supplementary_benefits: true,
        supplementary_debt: true,
        supplementary_ill_health: true,
        supplementary_defined_benefit_pensions: true,
        requested_digital: false,
        number_of_previous_appointments: 0,
        count_of_pension_pots: 1,
        email: 'joe@bloggs.com',
        retirement_income_other_state_benefits: false,
        retirement_income_employment: false,
        retirement_income_partner: false,
        retirement_income_interest_or_savings: false,
        retirement_income_property: false,
        retirement_income_business: false,
        retirement_income_inheritance: false,
        retirement_income_other_income: false,
        retirement_income_unspecified: false
      )
    end
  }.freeze

  private_constant :FIXTURES
end

World(Fixtures)
