require 'rails_helper'

RSpec.describe User, type: :model do
  subject { described_class.new }

  it { is_expected.to have_many(:appointment_summaries) }

  context 'when a full name is set' do
    subject { described_class.new(name: 'Joe Bloggs') }

    it 'has a name' do
      expect(subject.name).to eq('Joe Bloggs')
    end

    it 'has a first name' do
      expect(subject.first_name).to eq('Joe')
    end

    it 'has a last name' do
      expect(subject.last_name).to eq('Bloggs')
    end
  end

  context 'when a first name and last name is set' do
    subject { described_class.new(first_name: 'Joe', last_name: 'Bloggs') }

    it 'has a name' do
      expect(subject.name).to eq('Joe Bloggs')
    end

    it 'has a first name' do
      expect(subject.first_name).to eq('Joe')
    end

    it 'has a last name' do
      expect(subject.last_name).to eq('Bloggs')
    end
  end

  context 'with an existing full name' do
    before do
      allow(subject).to receive(:read_attribute).with(:name) { 'Joe Bloggs' }
    end

    it 'has a name' do
      expect(subject.name).to eq('Joe Bloggs')
    end

    it 'has a first name' do
      expect(subject.first_name).to eq('Joe')
    end

    it 'has a last name' do
      expect(subject.last_name).to eq('Bloggs')
    end
  end
end
