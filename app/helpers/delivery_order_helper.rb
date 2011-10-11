module DeliveryOrderHelper
  def delivery_type(delivery_order)
    delivery_order.pickup? ? "Pickup" : "Delivery"
  end

  def delivery_slot(delivery_order)
    delivery_order.scheduled? ? "#{delivery_order.delivery_date.strftime("%d %b")} - #{delivery_order.delivery_slot.name}" : ""
  end
end