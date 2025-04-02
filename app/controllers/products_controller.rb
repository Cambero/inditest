class ProductsController < ApplicationController
  def index
    authorize Product

    @q = policy_scope(Product).ransack(params[:q], auth_object: set_ransack_auth_object)

    render json: ProductSerializer.new(@q.result, { params: { admin: current_user.is_admin? } })
  end

  def show
    authorize Product

    @product = policy_scope(Product).find(params[:id])

    render json: ProductSerializer.new(@product, { params: { admin: current_user.is_admin? } })
  end

  private

  def set_ransack_auth_object
    current_user.is_admin? ? :admin : nil
  end
end
