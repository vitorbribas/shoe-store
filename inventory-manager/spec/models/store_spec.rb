# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Store, type: :model do
  subject(:store) { build(:store) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe 'relationships' do
    it { should have_many(:inventories) }
    it { should have_many(:models).through(:inventories) }

    it do
      store = build(:store)

      expect(store).to have_many(:subscribed_customers)
        .class_name('Customer')
        .conditions(store_id: store.id)
    end
  end

  describe '#current_amount_of' do
    subject(:current_amount_of) { store.current_amount_of(model_name) }

    let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }
    let(:cache) { Rails.cache }

    before { store.save }

    context 'when model name exists' do
      let(:cache_key) { store.send(:cache_key_for, model_name) }
      let(:model) { create(:model) }
      let(:model_name) { model.name }

      before { allow(Rails).to receive(:cache).and_return(memory_store) }

      context 'when model has inventory register' do
        let(:latest_inventory) { store.inventories.last }

        before do
          create_list(:inventory, 3, store:, model:)
          Rails.cache.clear
        end

        it :aggregate_failures do
          expect(Rails.cache.exist?(cache_key)).to be_falsy

          expect(current_amount_of).to eq(latest_inventory.amount)

          expect(Rails.cache.read(cache_key)).to eq(latest_inventory.id)
        end
      end

      context 'when model doesnt have inventory register' do
        it :aggregate_failures do
          expect(Rails.cache.exist?(cache_key)).to be_falsy

          expect(current_amount_of).to be_zero

          expect(Rails.cache.read(cache_key)).to eq(nil)
        end
      end
    end

    context 'when model name doesnt exist' do
      let(:model_name) { 'bla' }

      it do
        expect { current_amount_of }.to raise_error(Store::InvalidModelName)
      end
    end
  end
end
