require "rails_helper"

RSpec.describe "Orders", type: :request do
  include AuthHelper
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:admin) { create(:user, :admin) }

  let(:units) { "3" }
  let(:product) { create(:product) }
  let(:params) { { units:, product_id: product.id } }

  describe "POST orders#create" do
    before do
      allow(AddProductToCart).to receive(:new).and_call_original
      auth_headers(user)
    end

    context "with valid params" do
      it "responds with created" do
        post("/users/#{user.id}/shopping_cart", params:)

        expect(AddProductToCart).to have_received(:new).with(user:, product:, units:)

        expect(response).to have_http_status :created
      end

      it "add the product" do
        expect {
          post("/users/#{user.id}/shopping_cart", params:)
        }.to change(Order, :count).by(1)
      end
    end

    context "with invalid params" do
      let(:units) { "-3" }

      it "responds with unprocessable_content" do
        post("/users/#{user.id}/shopping_cart", params:)

        expect(response).to have_http_status :unprocessable_content
      end

      it "does not add the product" do
        expect {
          post("/users/#{user.id}/shopping_cart", params:)
        }.to_not change(Order, :count)
      end
    end

    context "as user is not authorized to add product to other user cart" do
      before do
        auth_headers(user)
      end

      it "responds with error" do
        expect {
          post("/users/#{other_user.id}/shopping_cart", params:)
        }.to raise_error Pundit::NotAuthorizedError
      end
    end

    context "as admin user is authorized to add product to other user cart" do
      before do
        auth_headers(admin)
        post("/users/#{user.id}/shopping_cart", params:)
      end

      it "responds with ok status" do
        expect(response).to have_http_status :created
      end
    end
  end
end
