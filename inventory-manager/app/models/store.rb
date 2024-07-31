# frozen_string_literal: true

class Store < ApplicationRecord
  class InvalidModelName < StandardError; end

  has_many :inventories, dependent: :destroy
  has_many :models, -> { distinct }, through: :inventories
  has_many :subscribed_customers,
    ->(store) { where(store_id: store.id) },
    class_name: 'Customer',
    dependent: :destroy,
    inverse_of: :store

  validates :name, presence: true

  def current_amount_of(model_name)
    raise InvalidModelName unless model_name.in? Model.pluck(:name)

    inventory_id = fetch_latest_inventory_id(model_name)

    inventories.find_by(id: inventory_id)&.amount || 0
  end

  private

  def fetch_latest_inventory_id(model_name)
    Rails.cache.fetch(cache_key_for(model_name)) do
      inventories.of_model(model_name).last&.id
    end
  end

  def cache_key_for(model_name)
    Inventory.cache_key_for(name, model_name)
  end
end
