class Customer < ApplicationRecord
  belongs_to :store
  belongs_to :model

  scope :by_model, ->(model_id) { where(model_id:) }

  validates :name, :email, presence: true
  validates :email, uniqueness: { scope: %i[store_id model_id] }
end
