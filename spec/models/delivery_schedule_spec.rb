require 'spec_helper'

describe DeliverySchedule do
  context "validations" do
    subject { Factory(:delivery_schedule) }
    it { should belong_to(:delivery_slot) }
    it { should validate_presence_of(:delivery_slot_id) }
    it { should validate_presence_of(:delivery_date) }
    it { should validate_uniqueness_of(:delivery_date).scoped_to(:delivery_slot_id)}
    it { should have_many(:delivery_orders) }
  end

  it "adds delivery orders to the schedule" do
    order = Factory(:delivery_order)
    schedule = Factory(:delivery_schedule)
    schedule.add_delivery_orders_by_id([order.id])
    DeliverySchedule.find(schedule.id).should have(1).delivery_orders
  end

  it "does not add the same delivery order to the schedule twice" do
    order = Factory(:delivery_order)
    schedule = Factory(:delivery_schedule, :delivery_orders => [order])
    schedule.add_delivery_orders_by_id([order.id])
    schedule.save!
    DeliverySchedule.find(schedule.id).should have(1).delivery_orders
  end

  it "knows the count of members who have deliveries in that schedule" do
    order1 = Factory(:delivery_order, :membership_no=>"M1")
    order2 = Factory(:delivery_order, :membership_no=>"M1")
    schedule = Factory(:delivery_schedule, :delivery_orders => [order1, order2])
    schedule.members_count.should == 1
  end

  it "should not allow more than specified upper limit of orders per slot" do
    orders = (OpacSettings.deliveries_per_slot).times.collect{|i| Factory(:delivery_order, :membership_no => "M#{i}") }
    schedule = Factory(:delivery_schedule, :delivery_orders => orders)
    schedule.delivery_orders << Factory(:delivery_order, :membership_no => "A001")
    schedule.should_not be_valid
    schedule.should have(1).error_on(:delivery_orders)
  end

  it "returns a set of deliveries grouped by member" do
    order1 = Factory(:delivery_order, :membership_no=>"M1")
    order2 = Factory(:delivery_order, :membership_no=>"M1")
    schedule = Factory(:delivery_schedule, :delivery_orders => [order1, order2])
    schedule.order_lists.should have(1).things
    schedule.order_lists[0].membership_no.should == "M1"
  end

  context "search by a date and slot" do
    let(:slot) { Factory(:delivery_slot) }
    let(:tomorrow) { Date.tomorrow }

    it "can search for a delivery schedule by date and slot id" do
      schedule = Factory(:delivery_schedule, :delivery_date => tomorrow, :delivery_slot => slot)
      DeliverySchedule.by_date_and_slot_id(tomorrow.strftime("%Y/%m/%d"), slot.id).should == schedule
    end

    it "returns a blank object if there is no schedule found" do
      schedule = DeliverySchedule.by_date_and_slot_id(tomorrow.strftime("%Y/%m/%d"), slot.id)
      schedule.should be_valid
      schedule.should have(0).delivery_orders
    end
  end
end
