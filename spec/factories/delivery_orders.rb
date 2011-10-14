FactoryGirl.define do
  factory :delivery_order do
    membership_no "M1234"
    title_id { Factory(:dev_title).id }
    ibtr { Factory(:ibtr) }
    status DeliveryOrder::PENDING
    branch_id 1
    created_by "Person"
    order_type DeliveryOrder::DELIVERY

    factory :ready_delivery_order do
      ibtr { Factory(:ibtr, :state => "Dispatched") }
    end

    factory :pending_delivery_order do
      ibtr { Factory(:ibtr, :state => "Assigned") }
    end
  end
end
