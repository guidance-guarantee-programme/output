# frozen_string_literal: true
require 'rails_helper'

RSpec.describe User, type: :model do
  subject { described_class.new }

  it { is_expected.to have_many(:appointment_summaries) }

  it 'defaults to non-admin upon initialisation' do
    expect(subject).to_not be_admin
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
end
