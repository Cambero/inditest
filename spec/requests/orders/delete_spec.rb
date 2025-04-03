require "rails_helper"

RSpec.describe "Orders", type: :request do
  include AuthHelper
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:admin) { create(:user, :admin) }

  let(:product) { create(:product) }
  let!(:order) { create(:order, product:, user:) }

  describe "DELETE orders#destroy" do
    before do
      allow(RemoveProductFromCart).to receive(:new).and_call_original
      auth_headers(user)
    end

    context "with valid params" do
      it "responds with no_content" do
        delete "/users/#{user.id}/shopping_cart/#{product.id}"

        expect(RemoveProductFromCart).to have_received(:new).with(user:, product:)

        expect(response).to have_http_status :no_content
      end

      it "remove the product" do
        expect {
          delete "/users/#{user.id}/shopping_cart/#{product.id}"
        }.to change(Order, :count).by(-1)
      end
    end

    context "with invalid product" do
      it "responds with not_found" do
        delete "/users/#{user.id}/shopping_cart/invalid-id"

        expect(response).to have_http_status :not_found
      end
    end

    context "as user is not authorized to remove the product from other user cart" do
      before do
        auth_headers(other_user)
      end

      it "responds with error" do
        expect {
          delete "/users/#{user.id}/shopping_cart/#{product.id}"
        }.to raise_error Pundit::NotAuthorizedError
      end
    end

    context "as admin user is authorized to remove the product from other user cart" do
      before do
        auth_headers(admin)
        delete "/users/#{user.id}/shopping_cart/#{product.id}"
      end

      it "responds with no_content" do
        expect(response).to have_http_status :no_content
      end
    end
  end
end
