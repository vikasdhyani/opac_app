require "spec_helper"

describe OrderList do
  context "load all live orders" do
    before(:each) do
      Factory(:delivery_order, :membership_no => "M1")
      Factory(:delivery_order, :membership_no => "M2")
      Factory(:delivery_order, :membership_no => "M2")
    end

    it "returns one order list per member" do
      lists = OrderList.all_by_date
      lists.size.should == 2
    end

    it "sorts order list most recent date" do
      lists = OrderList.all_by_date
      lists[0].membership_no.should == "M2"
      lists[1].membership_no.should == "M1"
    end

    it "should give orders per member" do
      lists = OrderList.all_by_date
      lists[0].orders.size.should == 2
      lists[1].orders.size.should == 1
    end

    it "loads orders by criteria" do
      lists = OrderList.all_matching(:membership_no => "M2")
      lists.size.should == 1
      lists[0].membership_no.should == "M2"
      end

    it "loads all orders if no criteria is specified" do
      lists = OrderList.all_matching(:membership_no => "")
      lists.size.should == 2
    end

    it "allows criteria to be specified on the schedules table" do
      schedule = Factory(:delivery_schedule)
      Factory(:delivery_order, :delivery_schedule => schedule)
      list = OrderList.all_matching("delivery_schedules.delivery_slot_id" => schedule.delivery_slot.id.to_s)
      list.size.should == 1
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
    lists = OrderList.all_by_date
    lists[0].name.should == "Blah"
  end

  context "sorting the order list" do
    it "returns the newest element first" do
      earlier_order_list = OrderList.new("foo", [Factory(:ready_delivery_order, :created_at => 2.days.ago)])
      later_order_list = OrderList.new("foo", [Factory(:ready_delivery_order, :created_at => 1.days.ago)])

      [earlier_order_list, later_order_list].sort.should == [later_order_list, earlier_order_list]
      [later_order_list, earlier_order_list].sort.should == [later_order_list, earlier_order_list]
    end

    it "returns a ready delivery before pending delivery" do
      earlier_order_list = OrderList.new("foo", [Factory(:ready_delivery_order, :created_at => 2.days.ago)])
      later_order_list = OrderList.new("foo", [Factory(:pending_delivery_order, :created_at => 1.days.ago)])

      [earlier_order_list, later_order_list].sort.should == [earlier_order_list, later_order_list]
      [later_order_list, earlier_order_list].sort.should == [earlier_order_list, later_order_list]
    end
  end
end