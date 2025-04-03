class RemoveProductFromCart
    def initialize(user:, product:)
      @user = user
      @product = product
    end

    def call
      Order.find_by!(user: @user, product: @product, status: "pending").destroy
    end
end
