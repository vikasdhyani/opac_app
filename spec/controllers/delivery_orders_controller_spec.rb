require 'spec_helper'

describe DeliveryOrdersController do
  before(:each) do
    sign_in Factory(:user, :email => "foo@bar.com")
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

    it "should create a delivery schedule presenter for the view" do
      get :index
      response.should be_success
      assigns[:delivery_schedule_presenter].should_not be_nil
    end

    it "should list all pending orders for give membership no" do
      Factory(:delivery_order, :membership_no => "member_not_matching_criteria")
      Factory(:delivery_order, :membership_no => "M2")
      get :index, :criteria => { :membership_no => "M2" }
      response.should be_success
      list = assigns[:order_lists]
      list.size.should == 1
      list[0].membership_no.should == "M2"
    end

    it "should persist the criteria" do
      Factory(:delivery_order, :membership_no => "M2")
      get :index, :criteria => { :membership_no => "M2" }
      response.should be_success
      criteria = assigns[:criteria]
      criteria.membership_no.should == "M2"
    end

    it "should create a criteria object that responds to all search criteria" do
      get :index, :criteria => { :membership_no => "M2" }
      response.should be_success
      [:membership_no, :order_type].each do |method|
        assigns[:criteria].should respond_to(method)
      end
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


  context "GET by slot and date" do
    it "should list all pending orders for give membership no ans slot and delivery date" do
      schedule = Factory(:delivery_schedule)
      Factory(:delivery_order, :membership_no => "M2", :delivery_schedule => schedule)
      get :search_by_slot_and_date, :membership_no => "M2", :slot_id => schedule.delivery_slot_id.to_s, :delivery_date => schedule.delivery_date.strftime("%Y/%m/%d")
      response.should be_success
      list = assigns[:order_list]
      list.membership_no.should == "M2"
    end
  end

end
