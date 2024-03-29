require 'spec_helper'

describe AppointmentsController do
  before(:each) do
    sign_in Factory(:user)
  end

  context "creating an appointment" do
    let(:delivery_order) { Factory(:delivery_order) }
    let(:delivery_slot) { Factory(:delivery_slot) }
    let(:tomorrow) { Date.tomorrow }

    it "creates the appointment on a particular date for a particular slot"do
      post :create, :delivery_date => tomorrow.strftime("%d/%b/%Y"), :delivery_slot_id => delivery_slot.id, :delivery_orders => [delivery_order.id]
      response.should be_success
      schedule = DeliverySchedule.find_by_delivery_slot_id(delivery_slot.id)
      schedule.delivery_date.should == tomorrow
      schedule.should have(1).delivery_orders
    end

    it "returns a un processable entity if the number of delivery slots is exceeded" do
      orders = OpacSettings.deliveries_per_slot.times.collect { |i| Factory(:delivery_order, :membership_no => "M8888#{i}") }
      Factory(:delivery_schedule, :delivery_orders => orders, :delivery_date =>tomorrow, :delivery_slot => delivery_slot)
      post :create, :delivery_date => tomorrow.strftime("%d/%b/%Y"), :delivery_slot_id => delivery_slot.id, :delivery_orders => [delivery_order.id]
      response.should be_unprocessable_entity
      response.body.should include("Delivery orders cannot")
    end
  end

  context "GET new" do
    it "renders new form with all delivery slots" do
      Factory(:delivery_slot, :name => "Morning")
      Factory(:delivery_slot, :name => "Afternoon")
      get :new
      response.should be_success
      list = assigns[:delivery_slots]
      list.should have(2).things
    end

    it "caches the rendered form" do
      Factory(:delivery_slot, :name => "Morning")
      Factory(:delivery_slot, :name => "Afternoon")
      get :new
      response.should have_header('Cache-Control' => 'max-age=10800, private')
    end
  end
end
