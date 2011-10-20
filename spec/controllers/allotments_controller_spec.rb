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

  context "POST create" do
    let(:slot) { Factory(:delivery_slot) }
    let(:delivery_person) { Factory(:delivery_person) }
    let(:tomorrow) { Date.tomorrow }

    it "saves the new allotment schedule" do
      Factory(:delivery_schedule, :delivery_date => tomorrow, :delivery_slot => slot)
      tomorrow_string = tomorrow.strftime("%Y/%m/%d")
      post :create, :delivery_date => tomorrow_string, :allotment => { :slot_id => slot.id, :delivery_people => { "M1" => delivery_person.id} }
      response.should redirect_to(delivery_schedule_allotment_path(:delivery_date => tomorrow_string))
      DeliverySchedule.find_by_delivery_date(tomorrow_string).should have(1).delivery_person_allotments
    end

    it "sets a flash message when saved" do
      Factory(:delivery_schedule, :delivery_date => tomorrow, :delivery_slot => slot)
      tomorrow_string = tomorrow.strftime("%Y/%m/%d")
      post :create, :delivery_date => tomorrow_string, :allotment => { :slot_id => slot.id, :delivery_people => { "M1" => delivery_person.id} }
      response.should be_redirect
      flash[:notice].should == "Delivery Person Allotted"
    end

    it "returns a 422 if save fails" do
      DeliverySchedule.any_instance.should_receive(:save).and_return(false)
      post :create, :delivery_date => "2010/02/01", :allotment => { :slot_id => slot.id, :delivery_people => { "M1" => delivery_person.id} }
      response.should be_unprocessable_entity
    end
  end
end
