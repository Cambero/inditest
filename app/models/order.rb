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
class Order < ApplicationRecord
  include UserTrackable

  enum :status, { pending: "pending", ordered: "ordered" }, prefix: true

  validates :product, presence: true
  validates :user, presence: true
  validates :units, numericality: { only_integer: true, greater_than: 0 }
  validates :unit_price, numericality: { greater_than: 0 }

  validates :expiration_date, comparison: { greater_than: -> { Time.now } }, if: :expiration_date

  belongs_to :user
  belongs_to :product

  delegate :name, to: :product
  delegate :thumb_url, to: :product, allow_nil: true

  scope :shopping_cart, ->(user) { status_pending.where(user:) }
  scope :order_history, ->(user) { status_ordered.where(user:) }

  scope :summary, ->(user) { order_history(user).select("order_date, sum(units * unit_price) as total, sum(units) as products").group(:order_date) }
  scope :detail, ->(user, order_date) { where(user:).where(order_date:) }

  def order_date_str
    order_date&.strftime("%Y%m%d%H%M%S")
  end
end
