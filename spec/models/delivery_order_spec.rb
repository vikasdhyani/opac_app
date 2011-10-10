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

  it { should belong_to(:title) }
  it { should belong_to(:ibtr)}
  it { should have_many(:delivery_notes)}
  it { should belong_to(:delivery_schedule) }
end
