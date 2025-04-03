require 'rails_helper'

RSpec.describe "Products", type: :request do
  include AuthHelper
  let(:user) { create(:user) }
  let(:params) { {} }

  describe "GET /index" do
    let(:result) { JSON.parse(response.body)["data"] }

    before :all do
      create_list(:product, 2, :clothing)
      create(:product, :books, name: "Alice in Wonderland", price: 9.99, users_score: 4)
      create(:product, :books, name: "Flow", price: 15.50, users_score: 2)
      create(:product, :books, name: "The Godfather", price: 19.90, users_score: 5)
      create(:product, :books, :discarded, name: "The Godfather 2", price: 21.50, users_score: 3)
    end

    before do
      auth_headers(user)
      get products_path, params:
    end

    it "responds with ok status" do
      expect(response).to have_http_status :ok
    end

    context "when user is admin" do
      let(:user) { create(:user, :admin) }

      it "can see discarded products" do
        expect(result.length).to eq(6)
      end

      context "can filter by deleted product" do
        let(:params) { { q: { discarded_at_not_null: "true" } } }

        it "responds with filtered products" do
          expect(result.length).to eq(1)
          expect(result.first["attributes"]["name"]).to eq("The Godfather 2")
        end
      end

      context "can filter by name" do
        let(:params) { { q: { name_eq: "The Godfather" } } }

        it "responds with filtered products" do
          expect(result.length).to eq(1)
          expect(result.first["attributes"]["name"]).to eq("The Godfather")
        end
      end

      context "can filter by category" do
        let(:params) { { q: { category_eq: "books" } } }

        it "responds with filtered products" do
          expect(result.length).to eq(4)
        end
      end

      context "can filter by price" do
        let(:params) { { q: { price_gteq: 15.0, price_lteq: 20.0 } } }

        it "responds with filtered products" do
          expect(result.length).to eq(2)
        end
      end

      context "can sort by price" do
        let(:params) { { q: { category_eq: "books", s: "price desc" } } }

        it "responds with sorted products" do
          expected_sort = [ "The Godfather 2", "The Godfather", "Flow", "Alice in Wonderland" ]
          result_sort = result.map { |product| product["attributes"]["name"] }

          expect(result_sort).to eq(expected_sort)
        end
      end

      context "can sort by users score" do
        let(:params) { { q: { category_eq: "books", s: "users_score desc" } } }

        it "responds with sorted products" do
          expected_sort = [ "The Godfather", "Alice in Wonderland", "The Godfather 2", "Flow" ]
          result_sort = result.map { |product| product["attributes"]["name"] }

          expect(result_sort).to eq(expected_sort)
        end
      end
    end

    context "when user is not admin" do
      it "can not see discarded products" do
        expect(result.length).to eq(5)
      end

      context "can not filter by deleted product" do
        let(:params) { { q: { discarded_at_not_null: "true" } } }

        it "responds with filtered products" do
          expect(result.length).to eq(5)
        end
      end

      context "can filter by name" do
        let(:params) { { q: { name_eq: "The Godfather" } } }

        it "responds with filtered products" do
          expect(result.length).to eq(1)
          expect(result.first["attributes"]["name"]).to eq("The Godfather")
        end
      end

      context "can filter by category" do
        let(:params) { { q: { category_eq: "books" } } }

        it "responds with filtered products" do
          expect(result.length).to eq(3)
        end
      end

      context "can filter by price" do
        let(:params) { { q: { price_gteq: 15.0, price_lteq: 20.0 } } }

        it "responds with filtered products" do
          expect(result.length).to eq(2)
        end
      end

      context "can sort by price" do
        let(:params) { { q: { category_eq: "books", s: "price asc" } } }

        it "responds with sorted products" do
          expected_sort = [ "Alice in Wonderland", "Flow", "The Godfather" ]
          result_sort = result.map { |product| product["attributes"]["name"] }

          expect(result_sort).to eq(expected_sort)
        end
      end

      context "can sort by users score" do
        let(:params) { { q: { category_eq: "books", s: "users_score asc" } } }

        it "responds with sorted products" do
          expected_sort = [ "Flow", "Alice in Wonderland", "The Godfather" ]
          result_sort = result.map { |product| product["attributes"]["name"] }

          expect(result_sort).to eq(expected_sort)
        end
      end
    end
  end

  describe "GET /show" do
    let(:result) { JSON.parse(response.body) }

    before :all do
      create(:product, :books, name: "The Godfather", price: 19.90, users_score: 5)
      create(:product, :books, :discarded, name: "The Godfather 2", price: 21.50, users_score: 3)
    end

    before do
      auth_headers(user)

      get product_path(product_id)
    end

    let(:product_id) { Product.find_by(name: "The Godfather") }

    it "responds with ok status" do
      expect(response).to have_http_status :ok
    end

    it "result does not include private fields" do
      expect(result.keys.include?("location")).to be_falsey
      expect(result.keys.include?("real_price")).to be_falsey
      expect(result.keys.include?("sold_units")).to be_falsey
      expect(result.keys.include?("discarded_at")).to be_falsey
    end


    context "when user is admin" do
      let(:user) { create(:user, :admin) }
      let(:product_id) { Product.find_by(name: "The Godfather 2") }

      it "can see deleted product" do
        expect(result["name"]).to eq("The Godfather 2")
      end

      it "result include private fields" do
        expect(result.keys.include?("location")).to be_present
        expect(result.keys.include?("real_price")).to be_present
        expect(result.keys.include?("sold_units")).to be_present
        expect(result.keys.include?("discarded_at")).to be_present
      end
    end

    context "when user is not admin" do
      let(:user) { create(:user) }
      let(:product_id) { Product.find_by(name: "The Godfather 2") }

      it "can not see deleted product" do
        expect(response).to have_http_status :not_found
      end
    end
  end

  xdescribe "POST /create"
  xdescribe "PATCH /update"
  xdescribe "DELETE /destroy"
end
