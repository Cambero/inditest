# permite procesar los productos en estado pendiente en el carrito de la compra del usuario.

# Esta acción implica:
# - Asegurarse de que se disponen de las unidades de los productos solicitadas.
# - En caso contrarío devolver un error informando de qué productos no están disponibles.

# - Actualizar el estado de los productos de pending a ordered .
# - Actualizar el campo order_date de los productos.
# - expiration_date = nil

# - Actualizar el contador de unidades disponibles de los productos procesados.

# - Enviar un correo al usuario indicando que el pedido se ha efectuado correctamente.


# ** Transacion para actualizar Product, Order # units
class ProcessCart
    class NotEnoughProducts < StandardError
    end

    def initialize(user)
      @user = user
    end

    def call
      unless enough_products?
        raise NotEnoughProducts.new("Insufficient products: #{insufficient_products.join(", ")}")
      end

      order_date = Time.now.strftime("%Y%m%d%H%M%S")

      ActiveRecord::Base.transaction do
        @cart.update_all(expiration_date: nil, order_date:)

        @cart.each do |order|
          product = order.product

          product.units = product.units - order.units
          product.sold_units = product.sold_units + order.units

          product.save!
        end
      end

      ProcessedCartMailer.processed(@user.id, order_date).deliver_later
    end

    def cart
      @cart ||= Order.shopping_cart(@user)
    end

    def enough_products?
      insufficient_products.empty?
    end

    def insufficient_products
      cart.filter_map do |order|
        order.name if order.units > order.product.units
      end
    end

end
