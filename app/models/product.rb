# == Schema Information
#
# Table name: products
#
#  id            :bigint           not null, primary key
#  category      :enum             not null
#  code          :string(10)       not null
#  description   :text
#  discarded_at  :datetime
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
#  index_products_on_discarded_at   (discarded_at)
#  index_products_on_updated_by_id  (updated_by_id)
#
class Product < ApplicationRecord
  include UserTrackable
  include Discard::Model

  has_one_attached :image do |attachable|
    attachable.variant :thumb, resize_to_limit: [ 100, 100 ], preprocessed: true
  end

  enum :category, { clothing: "clothing", electronics: "electronics", books: "books", beauty: "beauty" }, prefix: true, validate: true

  validates :name, presence: true
  validates :code, presence: true, length: { is: 10 }, format: { with: /\A[a-zA-Z0-9]+\z/ }
  validates :code, uniqueness: true, if: :code_changed?
  validates :units, numericality: { only_integer: true, greater_than: 0 }
  validates :users_score, numericality: { only_integer: true, in: 1..5 }

  has_many :orders

  def soft_delete
    discard

    orders.status_pending.destroy_all
  end

  def image_url
    Rails.application.routes.url_helpers.url_for(image) if image.attached?
  end

  def thumb_url
    Rails.application.routes.url_helpers.url_for(image.variant(:thumb)) if image.attached?
  end

  def self.ransackable_attributes(auth_object = nil)
    if auth_object == :admin
      %w[name category price discarded_at]
    else
      %w[name category price]
    end
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  def self.ransortable_attributes(auth_object = nil)
    %w[price users_score]
  end
end
