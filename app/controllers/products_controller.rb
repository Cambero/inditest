class ProductsController < ApplicationController
  before_action :fetch_product, only: %i[ show update destroy ]

  def index
    authorize Product

    @q = policy_scope(Product).ransack(params[:q], auth_object: set_ransack_auth_object)

    render json: ProductSerializer.new(@q.result, { params: { admin: current_user.is_admin? } })
  end

  def show
    authorize Product

    render json: ProductSerializer.new(@product, { params: { admin: current_user.is_admin? } }).serializable_hash[:data][:attributes]
  end

  def create
    authorize Product

    @product = Product.new(permitted_attributes(Product))

    if @product.save
      render json: ProductSerializer.new(@product, { params: { admin: current_user.is_admin? } })
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize Product

    if @product.update(permitted_attributes(Product))
      render json: ProductSerializer.new(@product, { params: { admin: current_user.is_admin? } }).serializable_hash[:data][:attributes]
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize Product

    @product.soft_delete
  end

  private

  def set_ransack_auth_object
    current_user.is_admin? ? :admin : nil
  end

  def fetch_product
    @product = policy_scope(Product).find(params[:id])

    authorize @product
  end
end
