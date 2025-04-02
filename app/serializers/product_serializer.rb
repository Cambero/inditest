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
class ProductSerializer
  include JSONAPI::Serializer

  attributes :code, :name, :category, :description, :images, :price, :units, :users_score, :image_url, :thumb_url

  is_admin = Proc.new { |record, params| params && params[:admin] == true }

  attribute :location, if: is_admin
  attribute :real_price, if: is_admin
  attribute :sold_units, if: is_admin
  attribute :discarded_at, if: is_admin
end
