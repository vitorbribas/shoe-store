# frozen_string_literal: true

FactoryBot.define do
  factory :inventory do
    store
    model
    amount { (20..50).to_a.sample }
  end
end
