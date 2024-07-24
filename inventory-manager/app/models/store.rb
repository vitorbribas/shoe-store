class Store < ApplicationRecord
  has_many :inventories
  has_many :models, -> { distinct }, through: :inventories

  validates :name, presence: true

  def current_amount_of(model_name)
    inventories.of_model(model_name).last&.amount || 0
  end
end
