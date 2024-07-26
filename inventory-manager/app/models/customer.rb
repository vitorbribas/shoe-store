class Customer < ApplicationRecord
  belongs_to :store
  belongs_to :model

  validates :name, :email, presence: true
  validates :email, uniqueness: { scope: %i[store_id model_id] }
end
