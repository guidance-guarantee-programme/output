FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    name 'Rick Sanchez'
    permissions ['signin']
  end

  factory :appointment_summary do
    user
    guider_name 'Morty Smith'
    title 'Mr'
    first_name 'Bob'
    last_name 'Smith'
    address_line_1 '10 London House'
    address_line_2 'London Road'
    address_line_3 'Havering'
    town 'Romford'
    county 'Essex'
    postcode 'RM1 1AL'
    country 'United Kingdom'
    date_of_appointment { Time.zone.today }
    sequence(:reference_number)
    has_defined_contribution_pension 'yes'
    value_of_pension_pots 15_000
    format_preference 'standard'
    appointment_type 'standard'
    number_of_previous_appointments 0
    requested_digital false
    email 'joe@bloggs.com'
  end
end
