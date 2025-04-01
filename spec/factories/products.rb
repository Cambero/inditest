# == Schema Information
#
# Table name: products
#
#  id            :bigint           not null, primary key
#  category      :enum             not null
#  code          :string(10)       not null
#  description   :text
#  images        :string           default([]), is an Array
#  location      :string
#  name          :string           not null
#  price         :decimal(, )      not null
#  real_price    :decimal(, )
#  sold_units    :integer          default(0)
#  units         :integer          default(0)
#  users_score   :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  created_by_id :bigint
#  updated_by_id :bigint
#
# Indexes
#
#  index_products_on_code           (code) UNIQUE
#  index_products_on_created_by_id  (created_by_id)
#  index_products_on_updated_by_id  (updated_by_id)
#
FactoryBot.define do
  factory :product do
    name { "product #{Faker::Lorem.word}" }
    category { %w[clothing electronics books beauty].sample }
    code { Faker::Alphanumeric.unique.alphanumeric(number: 10) }
    units { rand(100) }
    users_score { rand(5).next }
    price { rand * 1000.0 }
    real_price { price * 0.6 }
    sold_units { 0 }
    location { Faker::Address.city }
    description { Faker::Lorem.sentence }

    trait :clothing do
      name { "shirt #{Faker::Creature::Animal.name}" }
      category { "clothing" }
    end

    trait :electronics do
      name { Faker::Device.model_name }
      category { "electronics" }
    end

    trait :books do
      name { Faker::Book.title }
      category { "books" }
    end

    trait :beauty do
      name { Faker::Book.title }
      category { "beauty" }
    end
  end
end
