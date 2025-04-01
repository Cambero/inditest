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
require 'rails_helper'

RSpec.describe Order, type: :model do
  describe "UserTrackable" do
    subject { build(:order) }

    it_behaves_like "UserTrackable"
  end

  it { is_expected.to validate_presence_of(:product) }
  it { is_expected.to validate_presence_of(:user) }
  it { is_expected.to validate_numericality_of(:units).only_integer.is_greater_than(0) }
  it { is_expected.to validate_numericality_of(:unit_price).is_greater_than(0) }
  it { is_expected.to validate_numericality_of(:unit_price).is_greater_than(0) }
  it { is_expected.to validate_comparison_of(:expiration_date).is_greater_than(Time.now) }

  it {
    should define_enum_for(:status)
    .with_values(described_class.statuses)
    .with_prefix
    .backed_by_column_of_type(:enum)
  }

  it { should belong_to(:user) }
  it { should belong_to(:product) }
end
