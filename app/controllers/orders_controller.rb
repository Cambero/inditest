class OrdersController < ApplicationController
  before_action :fetch_user, only: %i[index show create destroy process_cart]
  before_action :fetch_product, only: %i[create destroy]

  def index
    orders_summary = Order.summary(@user)

    render json: OrderSummarySerializer.new(orders_summary)
  end

  def show
    order_details = Order.detail(@user, params[:order_date])

    render json: OrderSerializer.new(order_details)
  end

  def create
    service = AddProductToCart.new(user: @user, product: @product, units: params[:units])

    if service.call
      render json: service.order, status: :created
    else
      render json: service.order.errors, status: :unprocessable_entity
    end
  end

  def destroy
    RemoveProductFromCart.new(user: @user, product: @product).call
  end

  def process_cart
    ProcessCart.new(@user).call
  rescue ProcessCart::NotEnoughProducts => e
    render json: e, status: :unprocessable_entity
  end

  private

  def fetch_user
    @user = User.find(params[:id])

    authorize @user, policy_class: OrderPolicy
  end

  def fetch_product
    @product = Product.kept.find(params[:product_id])
  end
end
