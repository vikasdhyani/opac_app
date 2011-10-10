require 'spec_helper'

describe DeliverySchedulesController do
  before(:each) do
    sign_in Factory(:user)
  end

  context "creating an appointment" do
    let(:delivery_order) { Factory(:delivery_order) }
    let(:delivery_slot) { Factory(:delivery_slot) }
    let(:tomorrow) { Date.tomorrow }
    let(:post_params) { {
        :year => tomorrow.year, :month => tomorrow.month, :date => tomorrow.day,
        :delivery_slot_id => delivery_slot.id, :delivery_orders => [delivery_order.id]
      }
    }

    it "creates the appointment on a particular date for a particular slot"do
      post :create_appointment, post_params
      response.should be_success
      schedule = DeliverySchedule.find_by_delivery_slot_id(delivery_slot.id)
      schedule.delivery_date.should == tomorrow
      schedule.should have(1).delivery_orders
    end

    it "returns a un processable entity if save fails" do
      DeliverySchedule.any_instance.stub(:save).and_return(false)
      post :create_appointment, post_params
      response.should be_unprocessable_entity
    end
  end
end
