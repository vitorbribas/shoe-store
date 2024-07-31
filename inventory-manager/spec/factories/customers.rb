# frozen_string_literal: true

FactoryBot.define do
  factory :customer do
    store
    model
    name { Faker::Name.name }
    email { Faker::Internet.email }
  end
end
