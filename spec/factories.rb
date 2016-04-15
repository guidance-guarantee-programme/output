FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password 'password'
    first_name 'Rick'
    last_name 'Sanchez'
    admin false
  end

  factory :appointment_summary do
    user
    guider_name 'Morty Smith'
    guider_organisation 'tpas'
    title 'Mr'
    last_name 'Smith'
    address_line_1 '10 London Road'
    town 'Romford'
    county 'Essex'
    postcode 'RM1 1AL'
    country 'United Kingdom'
    date_of_appointment { Time.zone.today }
    sequence(:reference_number)
    has_defined_contribution_pension 'yes'
    income_in_retirement 'pension'
  end
end
