require "rspec"

describe DeliveryNotesController do
  before(:each) do
    sign_in Factory(:user)
  end

  context "POST create" do
    it "should create a delivery note" do
      order = Factory(:delivery_order)
      post :create, :delivery_order_id => order.id, :delivery_note => { :content => "foobar" }
      response.should be_success
      DeliveryOrder.find(order.id).delivery_notes[0].content == "foobar"
    end
    it "should not create a note without contents" do
      order = Factory(:delivery_order)
      post :create, :delivery_order_id => order.id, :delivery_note => { }
      response.should be_unprocessable_entity
    end
  end
end