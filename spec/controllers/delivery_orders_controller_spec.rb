require 'spec_helper'

describe DeliveryOrdersController do
  before(:each) do
    sign_in Factory(:user)
  end

  context "GET index" do
    it "should list all pending orders" do
      Factory(:delivery_order, :membership_no => "M2")
      get :index
      response.should be_success
      list = assigns[:order_lists][0]
      list.membership_no.should == "M2"
    end

    it "should paginate to 5 members" do
      (1..10).each { |i| Factory(:delivery_order, :membership_no => "M00#{i}") }
      get :index
      response.should be_success
      list = assigns[:order_lists]
      list.should have(5).things
    end
  end

  context "GET search" do
    it "should list all pending orders for give membership no" do
      Factory(:delivery_order, :membership_no => "M2")
      get :search, :criteria => { :membership_no => "M2" }
      response.should be_success
      list = assigns[:order_lists]
      list.size.should == 1
      list[0].membership_no.should == "M2"
    end
  end

  context "GET table" do
    it "should list all pending orders for give membership no" do
      Factory(:delivery_order, :membership_no => "M2")
      get :table, :membership_no => "M2"
      response.should be_success
      list = assigns[:order_list]
      list.membership_no.should == "M2"
    end
  end
end
