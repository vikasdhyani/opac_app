Factory.define :delivery_order do |delivery_order|
  delivery_order.membership_no "M1234"
  delivery_order.title_id 1234
  delivery_order.ibtr { Factory(:ibtr) }
  delivery_order.status DeliveryOrder::PENDING
  delivery_order.branch_id 1
  delivery_order.created_by "Person"
  delivery_order.order_type DeliveryOrder::DELIVERY
end
