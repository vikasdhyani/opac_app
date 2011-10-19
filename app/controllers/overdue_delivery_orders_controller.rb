 class OverdueDeliveryOrdersController < DeliveryOrdersController

   def index
     prepare_for_index OrderList.overdue_orders
     render 'delivery_orders/index'
   end

 end