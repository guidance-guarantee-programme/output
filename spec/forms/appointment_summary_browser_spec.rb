# frozen_string_literal: true
require 'rails_helper'

RSpec.describe AppointmentSummaryBrowser do
  let(:search_string) { nil }
  subject { described_class.new(page: nil, start_date: nil, end_date: nil, search_string: search_string) }

  context 'when initializing' do
    it 'defaults the start and end dates' do
      expect(subject.start_date).to eq(1.month.ago.to_date)
      expect(subject.end_date).to eq(Time.zone.today)
    end
  end

  describe '#results' do
    let(:page_size_plus_one) { Kaminari.config.default_per_page + 1 }

    it 'returns results within the provided date range' do
      present = create(:appointment_summary, date_of_appointment: Time.zone.today)
      create(:appointment_summary, date_of_appointment: 1.year.ago)

      expect(subject.results).to eq([present])
    end

    context 'with search string filter for reference_number' do
      let(:search_string) { '123456' }

      it 'can match against the customer last_name' do
        last_name = create(:appointment_summary, reference_number: search_string)
        create(:appointment_summary, reference_number: '654321')

        expect(subject.results).to eq([last_name])
      end
    end

    context 'with search string filter for last_name' do
      let(:search_string) { 'Search text' }

      it 'can match against the customer last_name' do
        last_name = create(:appointment_summary, last_name: search_string)
        create(:appointment_summary, last_name: 'Other value')

        expect(subject.results).to eq([last_name])
      end

      it 'will match case insensitive and partial values' do
        upcase = create(:appointment_summary, last_name: search_string.upcase)
        downcase = create(:appointment_summary, last_name: search_string.downcase)

        expect(subject.results).to eq([upcase, downcase])
      end

      it 'will match case insensitive and partial values' do
        with_before_text = create(:appointment_summary, last_name: "before value #{search_string}")
        with_after_text = create(:appointment_summary, last_name: "#{search_string} after value")

        expect(subject.results).to eq([with_before_text, with_after_text])
      end
    end

    it 'is unpaginated' do
      create_list(:appointment_summary, page_size_plus_one)

      expect(subject.results.size).to eq(page_size_plus_one)
    end

    context 'on postgres `DateStyle` iso, mdy servers (travis-ci)' do
      it 'will not overflow for UK formatted dates' do
        expect do
          described_class.new(
            page: nil,
            start_date: '15/01/2016',
            end_date: '16/01/2016',
            search_string: nil
          ).results
        end.not_to raise_error
      end
    end
  end
end
