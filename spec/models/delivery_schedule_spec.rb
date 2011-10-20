require 'spec_helper'

describe DeliverySchedule do
  context "validations" do
    subject { Factory(:delivery_schedule) }
    it { should belong_to(:delivery_slot) }
    it { should validate_presence_of(:delivery_slot_id) }
    it { should validate_presence_of(:delivery_date) }
    it { should validate_uniqueness_of(:delivery_date).scoped_to(:delivery_slot_id)}
    it { should have_many(:delivery_orders) }
    it { should have_many(:delivery_person_allotments) }
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

  context "alloting delivery boys for a member" do
    let(:schedule) { Factory(:delivery_schedule) }
    let(:person) { Factory(:delivery_person, :name => "P1") }

    it "finds the delivery boy alloted to a particular member" do
      Factory(:delivery_person_allotment, :delivery_schedule => schedule, :membership_no => "M1", :delivery_person => person)
      schedule.delivery_person_for_membership_no("M1").should == person
    end

    it "returns nil if the delivery person is not found" do
      Factory(:delivery_person_allotment)
      schedule.delivery_person_for_membership_no("M150").should be_nil
    end

    it "saves the allotment of a delivery person against a member" do
      schedule.allot_delivery_people("M1" => person.id)
      schedule.save!
      schedule.should have(1).delivery_person_allotments
      schedule.delivery_person_for_membership_no("M1").should == person
    end

    it "resets the allotment if the delivery person id is blank" do
      schedule.allot_delivery_people("M1" => "")
      schedule.save!
      schedule.should have(1).delivery_person_allotments
      schedule.delivery_person_for_membership_no("M1").should be_nil
    end

    it "changes the allotment to a particular member" do
      Factory(:delivery_person_allotment, :delivery_schedule => schedule, :membership_no => "M1", :delivery_person => person)
      person2 = Factory(:delivery_person, :name => "P2")
      schedule.allot_delivery_people("M1" => person2.id)
      schedule.save!
      schedule.should have(1).delivery_person_allotments
      schedule.delivery_person_for_membership_no("M1").should == person2
    end

    it "finds the members alloted to a particular delivery person" do
      Factory(:delivery_person_allotment, :delivery_schedule => schedule, :membership_no => "M1", :delivery_person => person)
      schedule.members_for_delivery_person(person).should == ["M1"]
    end
    it "finds the delivery orders for a delivery person" do
      Factory(:delivery_person_allotment, :delivery_schedule => schedule, :membership_no => "M1", :delivery_person => person)
      order = Factory(:delivery_order, :membership_no => "M1", :delivery_schedule => schedule)
      schedule.delivery_orders_for_delivery_person(person).should == [order]
    end
  end
end
