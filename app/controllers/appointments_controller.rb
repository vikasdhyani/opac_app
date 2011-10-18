class AppointmentsController < ApplicationController
  def create
    delivery_date = Date.parse(params[:delivery_date])
    schedule = DeliverySchedule.by_date_and_slot_id(delivery_date, params[:delivery_slot_id])
    schedule.add_delivery_orders_by_id params[:delivery_orders]
    if schedule.save
      render :text => "Selected deliveries scheduled successfully"
    else
      render :json => { :errors => schedule.errors.full_messages }, :status => :unprocessable_entity
    end
  end

  def new
    @delivery_slots = DeliverySlot.all
    expires_in 3.hours
    render :layout => false
  end
end
