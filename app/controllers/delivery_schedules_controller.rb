class DeliverySchedulesController < ApplicationController
  def create_appointment
    delivery_date = Date.new(params[:year], params[:month], params[:date])
    schedule = DeliverySchedule.find_or_create_by_delivery_date_and_delivery_slot_id(delivery_date, params[:delivery_slot_id])
    schedule.add_delivery_orders_by_id params[:delivery_orders]
    head :status => :ok
  end
end
