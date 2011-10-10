class DeliveryOrderController < ApplicationController
  def index
    @order_lists = OrderList.all_by_date.paginate(:page => params[:page], :per_page => 5)
  end

  def search
    @order_lists = OrderList.all_matching(params[:criteria]).paginate(:page => params[:page], :per_page => 5)
    render :index
  end
end
