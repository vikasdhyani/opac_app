require "rspec"

describe DeliverySchedulePresenter do
  it "should show deliveries for upcoming week" do
    delivery_schedule = Factory(:delivery_schedule, :delivery_date => Date.tomorrow)
    order = Factory(:delivery_order, :delivery_schedule => delivery_schedule)
    delivery_plan = DeliverySchedulePresenter.new
    delivery_plan.deliveries_on(delivery_schedule.delivery_date, delivery_schedule.delivery_slot).should == [order]
  end

  it "should return an empty array for when the schedule does not exist" do
    delivery_plan = DeliverySchedulePresenter.new
    delivery_plan.deliveries_on(Date.tomorrow, Factory(:delivery_slot)).should == []
  end

  it "should know the dates for delivery schedules for upcoming week" do
    delivery_plan = DeliverySchedulePresenter.new
    dates = delivery_plan.dates
    dates.size.should == 7
    dates[0].should == Date.today
    dates[6].should == Date.today.advance(:days=> 6)
  end

  it "should know the delivery slots for delivery schedules of upcoming week" do
    delivery_slot = Factory(:delivery_slot)
    delivery_plan = DeliverySchedulePresenter.new
    delivery_plan.slots.should == [delivery_slot]
  end

  it "should know the count of deliveries for delivery schedules of upcoming week" do
    delivery_schedule = Factory(:delivery_schedule, :delivery_date => Date.tomorrow)
    Factory(:delivery_order, :delivery_schedule => delivery_schedule)
    delivery_plan = DeliverySchedulePresenter.new
    delivery_plan.members_count(delivery_schedule.delivery_date, delivery_schedule.delivery_slot).should == 1
  end

  it "counts two deliveries to the same member as a single delivery" do
    delivery_schedule = Factory(:delivery_schedule, :delivery_date => Date.tomorrow)
    Factory(:delivery_order, :delivery_schedule => delivery_schedule, :membership_no => "M1234")
    Factory(:delivery_order, :delivery_schedule => delivery_schedule, :membership_no => "M1234")
    delivery_plan = DeliverySchedulePresenter.new
    delivery_plan.members_count(delivery_schedule.delivery_date, delivery_schedule.delivery_slot).should == 1
  end
end