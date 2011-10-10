require 'spec_helper'

describe DeliverySchedulesController do
  before(:each) do
    sign_in Factory(:user)
  end

  it "creates an appointment on a particular date" do
    delivery_order = Factory(:delivery_order)
    delivery_slot = Factory(:delivery_slot)
    tomorrow = Date.tomorrow
    post :create_appointment, :year => tomorrow.year, :month => tomorrow.month, :date => tomorrow.day,
         :delivery_slot_id => delivery_slot.id, :delivery_orders => [delivery_order.id]
    response.should be_success
    DeliverySchedule.find_by_delivery_slot_id(delivery_slot.id).should have(1).delivery_orders
  end
end
