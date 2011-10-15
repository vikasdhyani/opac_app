require 'spec_helper'

describe DeliveryOrder do
  it "gets the live orders in the system" do
    order1 = Factory(:delivery_order, :status => DeliveryOrder::PENDING)
    order2 = Factory(:delivery_order, :status => DeliveryOrder::DONE)
    DeliveryOrder.live_orders.all.should == [order1]
  end

  it "knows if it is a pickup" do
    Factory(:delivery_order, :order_type => DeliveryOrder::PICKUP).should be_pickup
    Factory(:delivery_order, :order_type => DeliveryOrder::DELIVERY).should_not be_pickup
  end

  it "is scheduled if it has a delivery schedule" do
    Factory(:delivery_order, :delivery_schedule => Factory(:delivery_schedule)).should be_scheduled
    Factory(:delivery_order, :delivery_schedule => nil).should_not be_scheduled
  end

  it "loads overdue orders" do
    overdue = Factory(:delivery_order, :delivery_schedule => Factory(:delivery_schedule, :delivery_date => Date.yesterday), :membership_no => "M1")
    Factory(:delivery_order, :delivery_schedule => Factory(:delivery_schedule, :delivery_date => Date.today), :membership_no => "M2")
    DeliveryOrder.overdue_orders.should == [overdue]
  end

  context "availability of the book" do
    it "should be available if the ibtr state is Dispatched" do
      order = Factory(:ready_delivery_order)
      order.should be_ready_for_processing
    end

    it "should be unavailable if the ibtr state is assigned" do
      order = Factory(:pending_delivery_order)
      order.should_not be_ready_for_processing
    end

    it "should be available always if it is a pickup" do
      order = Factory(:delivery_order, :order_type => DeliveryOrder::PICKUP, :ibtr => nil)
      order.should be_ready_for_processing
    end
  end

  context "containing notes" do
    it "stores the note in the delivery order" do
      order = Factory(:delivery_order)
      Factory(:delivery_note, :delivery_order_id => order.id)

      reloaded = DeliveryOrder.find(order.id)
      reloaded.should have(1).delivery_notes
    end
  end

  context "cancel delivery order" do
    it "marks a delivery order as closed" do
      order = Factory(:delivery_order, :status => DeliveryOrder::PENDING)
      order.cancel("vikas@strata.co.in")
      order.status.should == DeliveryOrder::CANCELLED
    end

    it "creates a delivery note on cancellation" do
      order = Factory(:delivery_order, :status => DeliveryOrder::PENDING)
      order.cancel("vikas@strata.co.in")
      order.should have(1).delivery_notes
      order.delivery_notes[0].content.starts_with?("Cancelled").should be_true
    end

    it "saves the name of the user in the note" do
      order = Factory(:delivery_order, :status => DeliveryOrder::PENDING)
      order.cancel("vikas@strata.co.in")
      order.delivery_notes[0].content.should include("vikas@strata.co.in")
    end

    it "should remove the order from schedule once cancelled" do
      order = Factory(:delivery_order, :status => DeliveryOrder::PENDING, :delivery_schedule => Factory(:delivery_schedule))
      order.cancel("a@b.com")
      order.should_not be_scheduled
    end
  end

  it { should belong_to(:title) }
  it { should belong_to(:ibtr)}
  it { should have_many(:delivery_notes)}
  it { should belong_to(:delivery_schedule) }
end
