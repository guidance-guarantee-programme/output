require 'securerandom'

FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    name 'Rick Sanchez'
    permissions %w(signin)

    trait :analyst do
      permissions %w(signin analyst)
    end

    trait :team_leader do
      permissions %w(signin team_leader)
    end

    trait :phone_guider do
      permissions %w(signin phone_bookings)
    end
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
    telephone_appointment true

    factory :notify_delivered_appointment_summary do
      requested_digital true
      notification_id { SecureRandom.uuid }
    end

    factory :populated_appointment_summary do
      value_of_pension_pots_is_approximate true
      guider_name 'Pênelopę'
      supplementary_benefits true
      supplementary_debt true
      supplementary_ill_health true
      supplementary_defined_benefit_pensions true
      count_of_pension_pots 1
    end

    trait :requested_digital do
      requested_digital true
    end
  end
end
