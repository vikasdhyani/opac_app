class OrderListsController < ApplicationController
  def index
    @order_lists = OrderList.all_by_date
  end
end
