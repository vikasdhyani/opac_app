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

    it "should persist the criteria" do
      Factory(:delivery_order, :membership_no => "M2")
      get :search, :criteria => { :membership_no => "M2" }
      response.should be_success
      criteria = assigns[:criteria]
      criteria.membership_no.should == "M2"
    end

    it "should create a delivery schedule presenter for the view" do
      get :search, :criteria => { :membership_no => "M2" }
      response.should be_success
      assigns[:delivery_schedule_presenter].should_not be_nil
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

  context "GET overdue orders" do
    it "should list all overdue orders" do
      Factory(:delivery_order, :membership_no => "M1", :delivery_schedule => Factory(:delivery_schedule, :delivery_date => Date.yesterday))
      Factory(:delivery_order, :membership_no => "M2", :delivery_schedule => Factory(:delivery_schedule, :delivery_date => Date.today))
      get :overdue
      response.should be_success
      list = assigns[:order_lists]
      list[0].membership_no.should == "M1"
    end

    it "creates a delivery_schedule presenter for the view" do
      get :overdue
      response.should be_success
      assigns[:delivery_schedule_presenter].should_not be_nil
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

  context "POST close delivery order" do
    it "should close the delivery order" do
      request.env["HTTP_REFERER"] = "http://google.com"
      order = Factory(:delivery_order, :status => DeliveryOrder::PENDING)
      post :closure, :delivery_order_id => order.id
      response.should redirect_to(request.env["HTTP_REFERER"])
      delivery_order = DeliveryOrder.find(order.id)
      delivery_order.status.should == DeliveryOrder::DONE
      delivery_order.delivery_notes[0].content.should include("foo@bar.com")
    end

    it "should return 422 if the delivery_order cannot be closed" do
      order = Factory(:delivery_order, :status => DeliveryOrder::PENDING)
      DeliveryOrder.any_instance.should_receive(:save).and_return(false)
      post :closure, :delivery_order_id => order.id
      response.should be_unprocessable_entity
    end
  end
end
