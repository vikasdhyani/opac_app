module DeliveryOrderHelper
  def delivery_type(delivery_order)
    delivery_order.pickup? ? "Pickup" : "Delivery"
  end
end