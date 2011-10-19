require 'spec_helper'

describe CancellationsController do
  before(:each) { sign_in Factory(:user) }

  context "POST create delivery order cancellation" do
    it "should cancel the delivery order" do
      request.env["HTTP_REFERER"] = "http://google.com"
      order = Factory(:delivery_order, :status => DeliveryOrder::PENDING)
      post :create, :delivery_order_id => order.id
      response.should redirect_to(request.env["HTTP_REFERER"])
      delivery_order = DeliveryOrder.find(order.id)
      delivery_order.status.should == DeliveryOrder::CANCELLED
      delivery_order.delivery_notes[0].content.should include("foobar@strata.co.in")
    end

    it "should return 422 if the delivery_order cannot be cancelled" do
      order = Factory(:delivery_order, :status => DeliveryOrder::PENDING)
      DeliveryOrder.any_instance.should_receive(:save).and_return(false)
      post :create, :delivery_order_id => order.id
      response.should be_unprocessable_entity
    end
  end
end