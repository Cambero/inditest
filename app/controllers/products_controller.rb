class ProductsController < ApplicationController
  def index
    authorize Product

    @q = policy_scope(Product).ransack(params[:q], auth_object: set_ransack_auth_object)

    render json: ProductSerializer.new(@q.result, { params: { admin: current_user.is_admin? } })
  end

  private

  def set_ransack_auth_object
    current_user.is_admin? ? :admin : nil
  end
end
