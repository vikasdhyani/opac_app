require 'spec_helper'

describe OrderListsController do
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
  end
end
