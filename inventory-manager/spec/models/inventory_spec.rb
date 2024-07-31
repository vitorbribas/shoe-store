# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Inventory do
  subject(:inventory) { build(:inventory) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:amount) }
  end

  describe 'relationships' do
    it { is_expected.to belong_to(:store) }
    it { is_expected.to belong_to(:model) }
  end

  describe '.of_model' do
    subject(:of_model) { described_class.of_model(model_name) }

    let(:model_name) { 'My model' }
    let(:model) { create(:model, name: model_name) }
    let(:store) { create(:store) }

    before do
      create_list(:inventory, 5, store:, model:)
      create_list(:inventory, 5, store:)
    end

    it do
      expect(of_model.size).to eq(5)
      expect(of_model.pluck(:model_id).all?(model.id)).to be_true
    end
  end

  describe '.cache_key_for' do
    subject(:cache_key_for) { described_class.cache_key_for('foo', 'bar') }

    it { expect(cache_key_for).to eq(%w[foo bar]) }
  end

  describe '#notify_model_available_again' do
    let(:model) { create(:model) }
    let(:store) { create(:store) }
    let(:previous_inventory) { create(:inventory, store:, model:, amount:) }

    before do
      create_list(:customer, 5, store:, model:)
      allow(Rails.cache).to receive(:fetch).and_return(previous_inventory.id)
    end

    context 'when model got back' do
      let(:amount) { 0 }
      let(:upcomming_inventory) { create(:inventory, store:, model:, amount: 10) }
      let(:subscribed_customers) { store.subscribed_customers.by_model(model.id) }

      it do
        expect { upcomming_inventory }
          .to change { ActionMailer::Base.deliveries.count }.by(subscribed_customers.size)
      end
    end

    context 'when model DID NOT get back' do
      let(:amount) { (20..50).to_a.sample }
      let(:upcomming_inventory) do
        create(:inventory, store:, model:, amount: (20..50).to_a.sample)
      end

      it do
        expect { upcomming_inventory }
          .not_to(change { ActionMailer::Base.deliveries.count })
      end
    end
  end
end
