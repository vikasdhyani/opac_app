class DeliverySchedulesController < ApplicationController
  def index
    @delivery_schedule_presenter = DeliverySchedulePresenter.new
    render :layout => false
  end

  def show
    @delivery_schedule = DeliverySchedule.find_or_initialize_by_delivery_date_and_delivery_slot_id(params[:delivery_date], params[:slot_id])
    @order_lists = OrderList.create_from_delivery_orders(@delivery_schedule.delivery_orders)
  end
end
