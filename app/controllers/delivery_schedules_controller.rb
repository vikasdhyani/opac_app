class DeliverySchedulesController < ApplicationController
  def index
    @delivery_schedule_presenter = DeliverySchedulePresenter.new
    render :layout => false
  end

  def show
    @delivery_schedule = DeliverySchedule.find_by_delivery_date_and_delivery_slot_id(params[:delivery_date], params[:slot_id]) || DeliverySchedule.new
    head :status => :ok
  end
end
