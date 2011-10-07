require "rspec"

describe DeliveryNotesController do
  before(:each) do
    sign_in Factory(:user)
  end

  context "POST create" do
    it "should create a delivery note" do
      order = Factory(:delivery_order)
      post :create, :delivery_order_id => order.id, :delivery_note => { :content => "foobar" }
      DeliveryOrder.find(order.id).delivery_notes[0].content == "foobar"
    end

    it "should redirect to the index page after creating the delivery note" do
      order = Factory(:delivery_order)
      post :create, :delivery_order_id => order.id, :delivery_note => { :content => "foobar" }
      response.should redirect_to(delivery_order_delivery_notes_path(order.id))
    end

    it "should not create a note without contents" do
      order = Factory(:delivery_order)
      post :create, :delivery_order_id => order.id, :delivery_note => { }
      response.should be_unprocessable_entity
    end
  end

  context "GET index" do
    it "returns a list of all notes for a delivery order" do
      order = Factory(:delivery_order, :membership_no => "M1234")
      Factory(:delivery_note, :delivery_order_id => order.id, :content => "foo")
      get :index, :delivery_order_id => order.id
      response.should be_success
      assigns[:notes][0].content.should == "foo"
      assigns[:delivery_order].id.should == order.id
    end

    it "returns a list of all notes for a delivery order in descending order of time" do
      order = Factory(:delivery_order)
      Factory(:delivery_note, :delivery_order_id => order.id, :content => "foo", :created_at => 2.day.ago)
      Factory(:delivery_note, :delivery_order_id => order.id, :content => "bar", :created_at => 1.day.ago)
      get :index, :delivery_order_id => order.id
      response.should be_success
      assigns[:notes].collect(&:content).should == ["bar", "foo"]
    end
  end
end