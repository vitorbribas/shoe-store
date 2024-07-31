# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Customer, type: :model do
  subject(:customer) { build(:customer) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it do
      is_expected.to validate_uniqueness_of(:email)
        .ignoring_case_sensitivity
        .scoped_to(%i[store_id model_id])
    end
  end

  describe 'relationships' do
    it { should belong_to(:store) }
    it { should belong_to(:model) }
  end

  describe '.by_model' do
    subject(:by_model) { described_class.by_model(model.id) }

    let(:model) { create(:model) }
    let(:store) { create(:store) }

    before do
      create_list(:customer, 5, store:, model:)
      create_list(:customer, 5, store:)
    end

    it do
      expect(by_model.size).to eq(5)
      expect(by_model.pluck(:model_id).all?(model.id)).to be_truthy
    end
  end
end
