 class OverdueDeliveryOrdersController < DeliveryOrdersController

   def index
     prepare_for_index OrderList.overdue_orders
     head :status => :ok
   end

 end