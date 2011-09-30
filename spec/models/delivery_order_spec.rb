require 'spec_helper'

describe DeliveryOrder do
  it "gets the live orders in the system" do
    order1 = Factory(:delivery_order, :status => DeliveryOrder::PENDING)
    order2 = Factory(:delivery_order, :status => DeliveryOrder::DONE)
    DeliveryOrder.live_orders.all.should == [order1]
  end

  it "is valid when constructed by the factory" do
    Factory.build(:delivery_order).should be_valid
  end

  it "knows if it is a pickup" do
    Factory(:delivery_order, :order_type => DeliveryOrder::PICKUP).should be_pickup
    Factory(:delivery_order, :order_type => DeliveryOrder::DELIVERY).should_not be_pickup
  end

  context "backed by a view" do
    it "is able to create a new DeliveryOrder for tests" do
      order = Factory.build(:delivery_order)
      order.save.should be_true
    end

    it "cannot update an existing DeliveryOrder" do
      order = Factory.create(:delivery_order)
      order.save.should be_false
    end
  end
end