require "rails_helper"

RSpec.describe "Orders", type: :request do
  include AuthHelper
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let(:result) { JSON.parse(response.body)["data"].map{ _1["attributes"]} }
  let(:order_date) { (2.days.ago).strftime("%Y%m%d%H%M%S") }
  let(:other_order_date) { (1.days.ago).strftime("%Y%m%d%H%M%S") }

  before do
    create(:product, :books, name: "The Godfather 2", price: 21.50, users_score: 3).tap do |product|
      create(:order, user:, product:, units: 3)
    end

    create(:product, :books, name: "Flow", price: 15.50, users_score: 2).tap do |product|
      create(:order, :ordered, order_date:, user:, product:, units: 3) # 15.50 * 3
      create(:order, :ordered, order_date:, user: other_user, product:, units: 1)
    end

    create(:product, :books, name: "Alice in Wonderland", price: 9.99, users_score: 4).tap do |product|
      create(:order, :ordered, order_date:, user:, product:, units: 2) # 9.99 * 2
    end

    create(:product, :books, name: "The Godfather", price: 19.90, users_score: 5).tap do |product|
      create(:order, :ordered, order_date: other_order_date, user:, product:, units: 1) # 19.90
    end
  end

  describe "GET orders#index" do
    before do
      auth_headers(user)
      get "/users/#{user.id}/orders"
    end

    it "responds with orders ordered by the user" do
      expect(response).to have_http_status :ok

      expect(result.length).to eq(2)
      expect(result[0]["products"]).to eq(3 + 2)
      expect(result[0]["total"].to_f).to eq(15.50 * 3 + 9.99 * 2)
      expect(result[0]["order_date"]).to eq(order_date)

      expect(result[1]["products"]).to eq(1)
      expect(result[1]["total"].to_f).to eq(19.90)
      expect(result[1]["order_date"]).to eq(other_order_date)
    end

    context "as user is not authorized to see the others user orders" do
      before do
        auth_headers(user)
      end

      it "responds with error" do
        expect {
          get "/users/#{other_user.id}/orders"
        }.to raise_error Pundit::NotAuthorizedError
      end
    end

    context "as admin user is authorized to see the other user orders" do
      before do
        auth_headers(admin)
        get "/users/#{user.id}/orders"
      end

      it "responds with ok status" do
        expect(response).to have_http_status :ok
      end
    end
  end

end
