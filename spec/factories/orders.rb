# == Schema Information
#
# Table name: orders
#
#  id              :bigint           not null, primary key
#  expiration_date :datetime
#  order_date      :datetime
#  status          :enum             not null
#  unit_price      :decimal(, )      not null
#  units           :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  created_by_id   :bigint
#  product_id      :bigint           not null
#  updated_by_id   :bigint
#  user_id         :bigint           not null
#
# Indexes
#
#  index_orders_on_created_by_id  (created_by_id)
#  index_orders_on_product_id     (product_id)
#  index_orders_on_updated_by_id  (updated_by_id)
#  index_orders_on_user_id        (user_id)
#
FactoryBot.define do
  factory :order do
    status { "pending" }
    unit_price { product.price }
    units { rand(3).next }
    expiration_date { 2.days.after }

    product
    user

    trait :ordered do
      status { "ordered" }
      expiration_date { nil }
      order_date { Date.today - rand(100).hours }
    end
  end
end
