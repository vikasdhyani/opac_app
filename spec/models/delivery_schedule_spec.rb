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
end
