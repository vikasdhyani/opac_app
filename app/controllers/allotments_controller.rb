class AllotmentsController < ApplicationController
  def show
    @delivery_date = params[:delivery_date]
    @delivery_people = DeliveryPerson.all
    @delivery_schedules = DeliverySlot.all.collect do |slot|
      DeliverySchedule.by_date_and_slot_id(@delivery_date, slot.id)
    end
  end

  def create
    schedule = DeliverySchedule.by_date_and_slot_id(params[:delivery_date], params[:allotment][:slot_id])
    schedule.allot_delivery_people(params[:allotment][:delivery_people])
    if schedule.save
      redirect_to delivery_schedule_allotment_path(:delivery_date => params[:delivery_date])
    else
      head :status => :unprocessable_entity
    end
  end
end
