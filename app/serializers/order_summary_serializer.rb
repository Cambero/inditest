class OrderSummarySerializer
  include JSONAPI::Serializer

  attributes :products, :total

  attribute :order_date do |order|
    order.order_date_str
  end

  set_id do |order|
    order.order_date_str
  end
end
