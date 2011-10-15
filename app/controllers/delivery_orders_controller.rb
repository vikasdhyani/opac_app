require 'ostruct'

class DeliveryOrdersController < ApplicationController
  def index
    prepare_for_index OrderList.all_by_date
  end

  def overdue
    prepare_for_index OrderList.overdue_orders
    render :index
  end

  def search
    @criteria = OpenStruct.new(params[:criteria])
    prepare_for_index OrderList.all_matching(params[:criteria])
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

  def prepare_for_index(order_lists)
    @order_lists = order_lists.paginate(:page => params[:page], :per_page => 5)
    @delivery_schedule_presenter = DeliverySchedulePresenter.new
  end

  def cancellation
    delivery_order = DeliveryOrder.find(params[:delivery_order_id])
    delivery_order.cancel(current_user.email)
    if delivery_order.save
      redirect_to :back
    else
      head :status => :unprocessable_entity
    end
  end
end
