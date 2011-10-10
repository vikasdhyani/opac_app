require "spec_helper"

describe DeliveryOrderHelper do

  it "should decode delivery type" do
    delivery_order = Factory(:delivery_order, :order_type => DeliveryOrder::DELIVERY)
    helper.delivery_type(delivery_order).should == 'Delivery'
  end

  it "should decode pickup type" do
    delivery_order = Factory(:delivery_order, :order_type => DeliveryOrder::PICKUP)
    helper.delivery_type(delivery_order).should == 'Pickup'
  end
end