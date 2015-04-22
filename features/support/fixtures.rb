module Fixtures
  def fixture(name)
    FIXTURES.fetch(name).call
  end

  FIXTURES = {
    populated_appointment_summary: proc do
      AppointmentSummary.new(
        title: 'Mr',
        first_name: 'Joe',
        last_name: 'Bloggs',
        address_line_1: 'HM Treasury',
        address_line_2: '1 Horse Guards Road',
        address_line_3: 'Westminster',
        town: 'London',
        county: 'Greater London',
        country: 'United Kingdom',
        postcode: 'SW1A 2HQ',
        date_of_appointment: '2015-02-05',
        reference_number: 1245,
        value_of_pension_pots: 35_000,
        upper_value_of_pension_pots: 55_000,
        value_of_pension_pots_is_approximate: true,
        income_in_retirement: 'pension',
        guider_name: 'Penelope',
        guider_organisation: 'tpas',
        has_defined_contribution_pension: 'yes',
        continue_working: true,
        unsure: true,
        leave_inheritance: true,
        wants_flexibility: true,
        wants_security: true,
        wants_lump_sum: true,
        poor_health: true,
        format_preference: 'standard'
      )
    end
  }

  private_constant :FIXTURES
end

World(Fixtures)
