class OrderListsController < ApplicationController
  def index
    @order_lists = OrderList.all_by_date
  end

  def search
    @order_lists = OrderList.all_matching(params[:criteria])
    head :status => :ok
  end
end
