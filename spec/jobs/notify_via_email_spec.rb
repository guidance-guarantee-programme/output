require 'rails_helper'

RSpec.describe NotifyViaEmail do
  let(:appointment_summary) { create(:appointment_summary) }
  let(:config) do
    double(
      :config,
      service_id: 'service',
      secret_id: 'secret',
      appointment_summary_template_id: 'template',
      welsh_appointment_summary_template_id: 'welsh_template',
      ineligible_template_id: 'ineligible_template',
      welsh_ineligible_template_id: 'welsh_ineligible_template',
      pdf_download_host: 'https://example.com'
    )
  end
  let(:personalisation) do
    {
      pdf_download_url: 'https://example.com/standard.pdf',
      reference_number: appointment_summary.reference_number,
      first_name: appointment_summary.first_name,
      guider_name: appointment_summary.guider_name,
      date_of_appointment: appointment_summary.date_of_appointment.to_fs(:pw_date_long),
      section_32: 'yes', # rubocop:disable Naming/VariableNumber
      adjustable_income: 'no',
      inherited_pot: 'no',
      fixed_term_annuity: 'no',
      updated_beneficiaries: 'no',
      regulated_financial_advice: 'yes',
      kept_track_of_all_pensions: 'no',
      interested_in_pension_transfer: 'yes',
      created_retirement_budget: 'no',
      know_how_much_state_pension: 'no',
      received_state_benefits: 'yes',
      pension_to_pay_off_debts: 'yes',
      living_or_planning_overseas: 'yes',
      finalised_a_will: 'no',
      setup_power_of_attorney: 'no'
    }
  end
  let(:client) { double('Notifications::Client', send_email: response) }
  let(:response) { double('Notifications::Client', id: '12345') }

  before do
    allow(Notifications::Client).to receive(:new).and_return(client)
  end

  describe 'Notify template selection' do
    context 'when eligible and Welsh' do
      it 'selects the correct template ID' do
        appointment_summary.welsh = true

        expect(client).to receive(:send_email).with(hash_including(
                                                      email_address: appointment_summary.email,
                                                      template_id: 'welsh_template'
                                                    ))

        described_class.perform_now(appointment_summary, config: config)
      end
    end

    context 'when ineligible and Welsh' do
      it 'selects the correct template ID' do
        appointment_summary.welsh = true
        appointment_summary.has_defined_contribution_pension = 'no'

        expect(client).to receive(:send_email).with(hash_including(
                                                      email_address: appointment_summary.email,
                                                      template_id: 'welsh_ineligible_template'
                                                    ))

        described_class.perform_now(appointment_summary, config: config)
      end
    end

    context 'when ineligible' do
      it 'selects the correct template ID' do
        appointment_summary.has_defined_contribution_pension = 'no'

        expect(client).to receive(:send_email).with(hash_including(
                                                      email_address: appointment_summary.email,
                                                      template_id: 'ineligible_template'
                                                    ))

        described_class.perform_now(appointment_summary, config: config)
      end
    end
  end

  context 'when the customer has a DC pension' do
    it 'sends a standard email notification' do
      expect(client).to receive(:send_email).with(
        {
          email_address: appointment_summary.email,
          template_id: 'template',
          personalisation: {
            pdf_download_url: 'https://example.com/standard.pdf',
            reference_number: appointment_summary.reference_number,
            first_name: appointment_summary.first_name,
            guider_name: appointment_summary.guider_name,
            date_of_appointment: appointment_summary.date_of_appointment.to_fs(:pw_date_long),
            section_32: 'yes', # rubocop:disable Naming/VariableNumber
            adjustable_income: 'no',
            inherited_pot: 'no',
            fixed_term_annuity: 'no',
            updated_beneficiaries: 'no',
            regulated_financial_advice: 'yes',
            kept_track_of_all_pensions: 'no',
            interested_in_pension_transfer: 'yes',
            created_retirement_budget: 'no',
            know_how_much_state_pension: 'no',
            received_state_benefits: 'yes',
            pension_to_pay_off_debts: 'yes',
            living_or_planning_overseas: 'yes',
            finalised_a_will: 'no',
            setup_power_of_attorney: 'no'
          }
        }
      )

      described_class.perform_now(appointment_summary, config: config)
    end
  end

  context 'when the customer does not have a DC pension' do
    let(:appointment_summary) do
      create(
        :appointment_summary,
        :has_defined_benefit_pension,
        covering_letter_type: 'adjustable_income',
        supplementary_defined_benefit_pensions: true
      )
    end

    it 'sends an eligible email notification' do
      expect(client).to receive(:send_email).with(
        {
          email_address: appointment_summary.email,
          template_id: 'template',
          personalisation: {
            pdf_download_url: 'https://example.com/standard-db.pdf',
            reference_number: appointment_summary.reference_number,
            first_name: appointment_summary.first_name,
            guider_name: appointment_summary.guider_name,
            date_of_appointment: appointment_summary.date_of_appointment.to_fs(:pw_date_long),
            section_32: 'no', # rubocop:disable Naming/VariableNumber
            adjustable_income: 'yes',
            inherited_pot: 'no',
            fixed_term_annuity: 'no',
            updated_beneficiaries: 'no',
            regulated_financial_advice: 'yes',
            kept_track_of_all_pensions: 'no',
            interested_in_pension_transfer: 'yes',
            created_retirement_budget: 'no',
            know_how_much_state_pension: 'no',
            received_state_benefits: 'yes',
            pension_to_pay_off_debts: 'yes',
            living_or_planning_overseas: 'yes',
            finalised_a_will: 'no',
            setup_power_of_attorney: 'no'
          }
        }
      )

      described_class.perform_now(appointment_summary, config: config)
    end
  end

  context 'when regenerating' do
    let(:appointment_summary) do
      create(:appointment_summary, notify_completed_at: '2017-02-02 13:00', notify_status: :delivered)
    end

    it 'ensures the record is polled for notify delivery status' do
      described_class.perform_now(appointment_summary, config: config)

      expect(appointment_summary.reload).to have_attributes(
        notification_id: '12345',
        notify_completed_at: nil,
        notify_status: 'pending'
      )
    end
  end
end
