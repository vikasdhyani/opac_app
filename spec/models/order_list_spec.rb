require "spec_helper"

describe OrderList do
  context "load all live orders" do
    before(:each) do
      Factory(:delivery_order, :membership_no => "M1")
      Factory(:delivery_order, :membership_no => "M2")
      Factory(:delivery_order, :membership_no => "M2")
    end


    it "returns one orderlist per member" do
      lists = OrderList.sorted_by_number_of_orders
      lists.size.should == 2
    end

    it "sorts order list by number of live orders" do
      lists = OrderList.sorted_by_number_of_orders
      lists[0].membership_no.should == "M2"
      lists[1].membership_no.should == "M1"
    end

    it "should give orders per member" do
      lists = OrderList.sorted_by_number_of_orders
      lists[0].orders.size.should == 2
      lists[1].orders.size.should == 1
    end
  end

  it "gets the number of pending pickups" do
    order = OrderList.new("Foobar", [Factory(:delivery_order, :order_type => DeliveryOrder::PICKUP),
                                      Factory(:delivery_order, :order_type => DeliveryOrder::DELIVERY)])
    order.number_of_pickups.should == 1
  end

  it "gets the member name" do
    Factory(:delivery_order, :membership_no => "M1")
    Factory(:dev_membership, :card_id => "M1", :member => "Blah")
    lists = OrderList.sorted_by_number_of_orders
    lists[0].name.should == "Blah"
  end
end
