# frozen_string_literal: true
FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password 'password'
    first_name 'Rick'
    last_name 'Sanchez'
    admin false

    factory :admin do
      admin true
    end
  end

  factory :appointment_summary do
    user
    guider_name 'Morty Smith'
    guider_organisation 'tpas'
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
    income_in_retirement 'pension'
    value_of_pension_pots 15_000
    format_preference 'standard'
    appointment_type 'standard'
  end
end