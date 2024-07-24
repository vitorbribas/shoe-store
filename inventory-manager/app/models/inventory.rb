class Inventory < ApplicationRecord
  belongs_to :store
  belongs_to :model

  scope :of_model, -> (name) { joins(:model).where(model: { name: }).order(created_at: :asc) }

  validates :amount, presence: true
end
