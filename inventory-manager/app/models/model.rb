class Model < ApplicationRecord
  has_many :inventories
  has_many :stores, -> { distinct }, through: :inventories

  validates :name, presence: true
end
