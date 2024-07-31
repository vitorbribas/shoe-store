# frozen_string_literal: true

class Inventory < ApplicationRecord
  belongs_to :store
  belongs_to :model

  scope :of_model, lambda { |name|
                     joins(:model).where(model: { name: }).order(created_at: :asc)
                   }

  validates :amount, presence: true

  after_create :notify_model_available_again
  after_create :update_latest_inventory_id

  class << self
    def cache_key_for(store_name, model_name)
      [store_name, model_name]
    end
  end

  private

  def notify_model_available_again
    previous_id = Rails.cache
      .fetch(self.class.cache_key_for(store.name, model.name)) { id }
    previous_inventory = self.class.find_by(id: previous_id)

    return unless model_got_back?(previous_inventory)

    notify_subscribed_customers!
  end

  def update_latest_inventory_id
    Rails.cache.write(self.class.cache_key_for(store.name, model.name), id)
  end

  def notify_subscribed_customers!
    store.subscribed_customers.by_model(model_id).find_each do |customer|
      CustomerMailer.model_available_again(customer).deliver_now
    end
  end

  def model_got_back?(previous)
    previous.amount.zero? && amount.positive?
  end
end
