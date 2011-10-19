require 'spec_helper'

describe OverdueDeliveryOrdersController do
  before(:each) { sign_in Factory(:user) }

  context "GET index" do
    it "should index all overdue orders" do
      Factory(:delivery_order, :membership_no => "M1", :delivery_schedule => Factory(:delivery_schedule, :delivery_date => Date.yesterday))
      Factory(:delivery_order, :membership_no => "M2", :delivery_schedule => Factory(:delivery_schedule, :delivery_date => Date.today))
      get :index
      response.should be_success
      list = assigns[:order_lists]
      list[0].membership_no.should == "M1"
    end

    it "creates a delivery_schedule presenter for the view" do
      get :index
      response.should be_success
      assigns[:delivery_schedule_presenter].should_not be_nil
    end

  end
end
