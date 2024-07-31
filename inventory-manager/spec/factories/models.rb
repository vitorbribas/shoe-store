# frozen_string_literal: true

FactoryBot.define do
  factory :model do
    name { Faker::Lorem.word }
  end
end
