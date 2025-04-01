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
require "rails_helper"

RSpec.describe Product, type: :model do
  describe "UserTrackable" do
    subject { build(:product) }

    it_behaves_like "UserTrackable"
  end

  it { is_expected.to validate_presence_of(:name) }

  describe "code" do
    it { is_expected.to validate_presence_of(:code) }
    it { is_expected.to validate_length_of(:code).is_equal_to(10) }
    it { is_expected.to validate_numericality_of(:units).only_integer.is_greater_than(0) }
    it { is_expected.to validate_numericality_of(:users_score).only_integer.is_in(1..5) }

    it { should allow_values("123456ASDF", "ASD1231230").for(:code) }
    it { should_not allow_values("_123456ASD", "SD1-231230", "SD1 231230").for(:code) }

    context "is uniq" do
      subject { create(:product) }

      it { is_expected.to validate_uniqueness_of(:code) }
    end
  end

  it {
    should define_enum_for(:category)
    .with_values(described_class.categories)
    .with_prefix
    .backed_by_column_of_type(:enum)
  }

  it { is_expected.to have_many(:orders) }
end
