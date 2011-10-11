require "spec_helper"

describe DeliveryOrderHelper do

  context "delivery type" do
    it "should decode delivery type" do
      delivery_order = Factory(:delivery_order, :order_type => DeliveryOrder::DELIVERY)
      helper.delivery_type(delivery_order).should == 'Delivery'
    end

    it "should decode pickup type" do
      delivery_order = Factory(:delivery_order, :order_type => DeliveryOrder::PICKUP)
      helper.delivery_type(delivery_order).should == 'Pickup'
    end
  end

  context "schedule date" do
    it "should show the formatted schedule date" do
      delivery_schedule = Factory(:delivery_schedule, :delivery_date => Date.new(2011, 02, 01), :delivery_slot => Factory(:delivery_slot, :name => "Evening"))
      delivery_order = Factory(:delivery_order, :delivery_schedule => delivery_schedule)
      helper.delivery_slot(delivery_order).should == '01 Feb - Evening'
    end

    it "shows an empty string if the delivery is not scheduled" do
      delivery_order = Factory(:delivery_order, :delivery_schedule => nil)
      helper.delivery_slot(delivery_order).should == ''
    end
  end
end