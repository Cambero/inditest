admin = User.create_with(password: "secret", name: "Admin", is_admin: true).find_or_create_by!(email: "admin@ecommerce.com")
customer = User.create_with(password: "secret", name: "Customer", is_admin: false).find_or_create_by!(email: "customer@ecommerce.com")
client = User.create_with(password: "secret", name: "Another", is_admin: false).find_or_create_by!(email: "client@ecommerce.com")

Order.delete_all
Product.delete_all

FactoryBot.create_list(:product, 20, :clothing)
FactoryBot.create_list(:product, 20, :books)
FactoryBot.create_list(:product, 20, :electronics)
FactoryBot.create_list(:product, 20, :beauty)

FactoryBot.create_list(:product, 5, :clothing, :discarded)
FactoryBot.create_list(:product, 5, :books, :discarded)
FactoryBot.create_list(:product, 5, :electronics, :discarded)
FactoryBot.create_list(:product, 5, :beauty, :discarded)


def create_orders_ordered(count, user)
  (1..count).each do |i|
    order_date = (Date.today - i.days).strftime("%Y%m%d%H%M%S")

    Product.kept.sample(5).each do |product|
      FactoryBot.create(:order, :ordered, order_date:, product:, user:)
    end
  end
end

def create_orders_pending(user)
  Product.kept.sample(5).each do |product|
    FactoryBot.create(:order, product:, user:)
  end
end

create_orders_ordered(3, customer)
create_orders_pending(customer)

create_orders_ordered(2, client)
create_orders_pending(client)
