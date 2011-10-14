require 'ostruct'

class DeliveryOrdersController < ApplicationController
  def index
    @order_lists = OrderList.all_by_date.paginate(:page => params[:page], :per_page => 5)
    @delivery_schedule_presenter = DeliverySchedulePresenter.new
  end

  def search
    @order_lists = OrderList.all_matching(params[:criteria]).paginate(:page => params[:page], :per_page => 5)
    @criteria = OpenStruct.new(params[:criteria])
    @delivery_schedule_presenter = DeliverySchedulePresenter.new
    render :index
  end

  def table
    @order_list = OrderList.all_matching(:membership_no => params[:membership_no])[0]
    render :partial => "table", :locals => { :order_list => @order_list }
  end

  def search_by_slot_and_date
    order_lists = OrderList.all_matching(:membership_no => params[:membership_no], "delivery_schedules.delivery_date" => params[:delivery_date], "delivery_schedules.delivery_slot_id" => params[:slot_id])
    @order_list = order_lists.first
    render :partial => "table", :locals => { :order_list => @order_list, :do_not_show_schedule_button => true }
  end
end
