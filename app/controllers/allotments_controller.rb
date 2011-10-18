class AllotmentsController < ApplicationController
  def show
    @delivery_date = params[:delivery_date]
    @delivery_people = DeliveryPerson.all
    @delivery_schedules = DeliverySlot.all.collect do |slot|
      DeliverySchedule.by_date_and_slot_id(@delivery_date, slot.id)
    end
  end

  def create
    render :text => YAML.dump(params)
  end
end
