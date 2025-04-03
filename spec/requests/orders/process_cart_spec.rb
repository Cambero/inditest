require "rails_helper"

RSpec.describe "Orders", type: :request do
  include AuthHelper
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:admin) { create(:user, :admin) }

  let(:cart) { Order.shopping_cart(user) }
  let(:result) { JSON.parse(response.body) }

  before do
    create(:product, :books, name: "The Godfather", price: 19.90, users_score: 5).tap do |product|
      create(:order, user:, product:, units: 3)
    end

    create(:product, :books, name: "Flow", price: 15.50, users_score: 2).tap do |product|
      create(:order, user:, product:, units: 1)
    end
  end

  describe "POST orders#process_cart" do
    before do
      allow(ProcessCart).to receive(:new).and_call_original
      auth_headers(user)
    end

    context "when there are enough products" do
      before do
        post "/users/#{user.id}/shopping_cart/process"
      end

      it "responds with no content" do
        expect(ProcessCart).to have_received(:new).with(user)

        expect(response).to have_http_status :no_content
      end

      it "shopping cart is empty" do
        expect(cart).to be_empty
      end
    end

    context "when there are not enough products" do
      before do
        cart.first.product.update(units: 1)

        post "/users/#{user.id}/shopping_cart/process"
      end

      it "responds with error" do
        expect(response).to have_http_status :unprocessable_content

        expect(result).to eq "Insufficient products: The Godfather"
      end
    end

    context "as user is not authorized to process the other user cart" do
      before do
        auth_headers(other_user)
      end

      it "responds with error" do
        expect {
          post "/users/#{user.id}/shopping_cart/process"
        }.to raise_error Pundit::NotAuthorizedError
      end
    end

    context "as admin user is authorized to add product to other user cart" do
      before do
        auth_headers(admin)
        post "/users/#{user.id}/shopping_cart/process"
      end

      it "responds with no_content" do
        expect(response).to have_http_status :no_content
      end
    end
  end
end
