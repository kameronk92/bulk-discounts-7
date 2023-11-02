require "faker"

FactoryBot.define do
  factory :item do
    name { Faker::Commerce.product_name }
    description { Faker::Lorem.sentence }
    unit_price { Faker::Number.number(digits: 5) } # adjust range as necessary
    association :merchant
  end
end