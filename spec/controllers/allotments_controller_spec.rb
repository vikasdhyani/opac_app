require 'spec_helper'

describe AllotmentsController do
  before(:each) { sign_in Factory(:user) }

  context "GET show" do
    it "loads a delivery schedules for every slot on a particular day" do
      Factory(:delivery_slot)
      Factory(:delivery_slot)
      get :show, :delivery_date => "2010/02/01"
      response.should be_success
      assigns[:delivery_schedules].should have(2).things
    end

    it "holds on to the delivery date for the view" do
      get :show, :delivery_date => "2010/02/01"
      response.should be_success
      assigns[:delivery_date].should == "2010/02/01"
    end

    it "holds on to all delivery people for the view" do
      delivery_person = Factory(:delivery_person)
      get :show, :delivery_date => "2010/02/01"
      response.should be_success
      assigns[:delivery_people].should == [delivery_person]
    end
  end
end
