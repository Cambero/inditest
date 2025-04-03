class RemoveExpiredProductsFromCarts
  def self.call
    deleted = Order.status_pending.where(expiration_date: ..Time.now).delete_all

    puts "RemoveExpiredProductsFromCarts deleted #{deleted} expired products"
  end
end
