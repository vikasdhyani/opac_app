require 'spec_helper'

describe DeliverySchedulesController do
  before(:each) do
    sign_in Factory(:user)
  end

   context "GET index" do
     it "should foo" do
      delivery_schedule = Factory(:delivery_schedule, :delivery_date => Date.tomorrow)
       order = Factory(:delivery_order, :delivery_schedule => delivery_schedule)
       get :index
       response.should be_success
       assigns[:delivery_schedule_presenter].slots.should == DeliverySlot.all
     end
   end
end
