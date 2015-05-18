require 'rails_helper'

RSpec.describe TransliteratedAppointmentSummary do
  subject(:transliterated_appointment_summary) { described_class.new(appointment_summary) }

  let(:first_name) { 'Joe' }
  let(:last_name) { 'Bloggs' }
  let(:address_line_1) { 'A house' }
  let(:address_line_2) { 'A street' }
  let(:address_line_3) { 'A district' }
  let(:town) { 'A town' }
  let(:county) { 'A county' }
  let(:postcode) { 'AB12 6BG' }
  let(:country) { 'A country' }
  let(:guider_name) { 'Mo' }

  let(:appointment_summary) do
    AppointmentSummary.new(first_name: first_name,
                           last_name: last_name,
                           address_line_1: address_line_1,
                           address_line_2: address_line_2,
                           address_line_3: address_line_3,
                           town: town,
                           county: county,
                           postcode: postcode,
                           country: country,
                           guider_name: guider_name)
  end

  describe '.first_name' do
    subject { transliterated_appointment_summary.first_name }

    let(:first_name) { 'Noemí' }

    it 'approximates non-ASCII characters' do
      is_expected.to eq('Noemi')
    end
  end

  describe '.last_name' do
    subject { transliterated_appointment_summary.last_name }

    let(:last_name) { 'López' }

    it 'approximates non-ASCII characters' do
      is_expected.to eq('Lopez')
    end
  end

  describe '.address_line_1' do
    subject { transliterated_appointment_summary.address_line_1 }

    let(:address_line_1) { 'Świętokrzyska' }

    it 'approximates non-ASCII characters' do
      is_expected.to eq('Swietokrzyska')
    end
  end

  describe '.address_line_2' do
    subject { transliterated_appointment_summary.address_line_2 }

    let(:address_line_2) { 'Kościuszki 14' }

    it 'approximates non-ASCII characters' do
      is_expected.to eq('Kosciuszki 14')
    end
  end

  describe '.address_line_3' do
    subject { transliterated_appointment_summary.address_line_3 }

    let(:address_line_3) { 'Łódź' }

    it 'approximates non-ASCII characters' do
      is_expected.to eq('Lodz')
    end
  end

  describe '.town' do
    subject { transliterated_appointment_summary.town }

    let(:town) { 'Poznań' }

    it 'approximates non-ASCII characters' do
      is_expected.to eq('Poznan')
    end
  end

  describe '.county' do
    subject { transliterated_appointment_summary.county }

    let(:county) { 'Częstochowa' }

    it 'approximates non-ASCII characters' do
      is_expected.to eq('Czestochowa')
    end
  end

  describe '.postcode' do
    subject { transliterated_appointment_summary.postcode }

    let(:postcode) { 'ÈÐ12 2ÅÌ' }

    it 'approximates non-ASCII characters' do
      is_expected.to eq('ED12 2AI')
    end
  end

  describe '.country' do
    subject { transliterated_appointment_summary.country }

    let(:country) { "Côte d'Ivoire" }

    it 'approximates non-ASCII characters' do
      is_expected.to eq("Cote d'Ivoire")
    end
  end

  describe '.guider_name' do
    subject { transliterated_appointment_summary.guider_name }

    let(:guider_name) { 'García' }

    it 'approximates non-ASCII characters' do
      is_expected.to eq('Garcia')
    end
  end
end
