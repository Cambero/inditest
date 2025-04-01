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
class Product < ApplicationRecord
  enum :category, { clothing: "clothing", electronics: "electronics", books: "books", beauty: "beauty" }, prefix: true, validate: true

  validates :name, presence: true
  validates :code, presence: true, length: { is: 10 }, format: { with: /\A[a-zA-Z0-9]+\z/ }
  validates :code, uniqueness: true, if: :code_changed?
  validates :units, numericality: { only_integer: true , greater_than: 0 }
  validates :users_score, numericality: { only_integer: true , in: 1..5 }

  has_many :orders
end
