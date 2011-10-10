class AppointmentsController < ApplicationController
  def create
    delivery_date = Date.parse(params[:delivery_date])
    schedule = DeliverySchedule.find_or_create_by_delivery_date_and_delivery_slot_id(delivery_date, params[:delivery_slot_id])
    schedule.add_delivery_orders_by_id params[:delivery_orders]
    if schedule.save
      head :status => :created
    else
      head :status => :unprocessable_entity
    end
  end

  def new
    @delivery_slots = DeliverySlot.all
    render :layout => false
  end
end
