class DeliverySchedulesController < ApplicationController
  def index
    @delivery_schedule_presenter = DeliverySchedulePresenter.new
    render :layout => false
  end

  def show
    @delivery_schedule = DeliverySchedule.find_or_initialize_by_delivery_date_and_delivery_slot_id(params[:delivery_date], params[:slot_id])
    p display_delivery_schedules_path(:delivery_date => "2010/05/02", :slot_id => 34)
    head :status => :ok
  end
end
