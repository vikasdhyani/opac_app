require 'spec_helper'

describe DeliverySchedulesController do
  before(:each) do
    sign_in Factory(:user)
  end

   context "GET index" do
     it "should load all slots for display on the UI" do
      delivery_schedule = Factory(:delivery_schedule, :delivery_date => Date.tomorrow)
       order = Factory(:delivery_order, :delivery_schedule => delivery_schedule)
       get :index
       response.should be_success
       assigns[:delivery_schedule_presenter].slots.should == DeliverySlot.all
     end
   end

   context "GET show" do
     let(:delivery_slot) { Factory(:delivery_slot) }
     let(:tomorrow) { Date.tomorrow }

     it "should get the list of all appointment for given delivery date and slot" do
       delivery_schedule = Factory(:delivery_schedule, :delivery_date => tomorrow, :delivery_slot => delivery_slot)
       get :show, :delivery_date => tomorrow.strftime("%Y/%m/%d"), :slot_id => delivery_slot.id
       response.should be_success
       assigns[:delivery_schedule].should == delivery_schedule
     end

     it "should get the list of all distinct appointments for given delivery date and slot" do
       Factory(:delivery_schedule, :delivery_date => tomorrow, :delivery_slot => delivery_slot, :delivery_orders => [Factory(:delivery_order)])
       get :show, :delivery_date => tomorrow.strftime("%Y/%m/%d"), :slot_id => delivery_slot.id
       response.should be_success
       assigns[:order_lists].size.should == 1
     end

    it "should create a delivery schedule presenter for the view" do
      get :show, :delivery_date => tomorrow.strftime("%Y/%m/%d"), :slot_id => delivery_slot.id
      response.should be_success
      assigns[:delivery_schedule_presenter].should_not be_nil
    end

     it "returns a new object if there is no schedule created" do
       get :show, :delivery_date => tomorrow.strftime("%Y/%m/%d"), :slot_id => delivery_slot.id
       response.should be_success
       assigns[:delivery_schedule].delivery_orders.should be_empty
       assigns[:delivery_schedule].delivery_slot.should == delivery_slot
     end
   end
end
