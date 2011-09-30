class OrderListsController < ApplicationController
  def index
    @order_lists = OrderList.sorted_by_number_of_orders
  end
end
