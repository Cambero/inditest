class AddProductToCart
    def initialize(user:, product:, units:)
      @user = user
      @product = product
      @units = units.to_i
    end

    def call
      order.units = order.units.to_i + @units
      order.unit_price = @product.price

      order.expiration_date = 2.days.after
      order.save
    end

    def order
      @order ||= Order.find_or_initialize_by(user: @user, product: @product, status: "pending")
    end
end
