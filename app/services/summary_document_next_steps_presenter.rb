class SummaryDocumentNextStepsPresenter
  STEP_RESPONSES = {
    updated_beneficiaries: %w(no unsure),
    regulated_financial_advice: %w(yes doesnt_know),
    kept_track_of_all_pensions: %w(no doesnt_know),
    interested_in_pension_transfer: %w(yes doesnt_know),
    created_retirement_budget: %w(no),
    know_how_much_state_pension: %w(no),
    received_state_benefits: %w(yes doesnt_know),
    pension_to_pay_off_debts: %w(yes doesnt_know),
    living_or_planning_overseas: %w(yes),
    finalised_a_will: %w(no),
    setup_power_of_attorney: %w(no)
  }.freeze

  def initialize(appointment_summary)
    @appointment_summary = appointment_summary
  end

  def to_h
    {}.tap do |responses|
      STEP_RESPONSES.each do |key, value|
        responses[key] = value.include?(@appointment_summary.public_send(key)) ? 'yes' : 'no'
      end
    end
  end
end
