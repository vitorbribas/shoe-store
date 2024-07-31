# frozen_string_literal: true

class Model < ApplicationRecord
  has_many :inventories, dependent: :destroy
  has_many :stores, -> { distinct }, through: :inventories

  validates :name, presence: true
end
