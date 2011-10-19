class CancellationsController < DeliveryOrdersController

  def create
    delivery_order = DeliveryOrder.find(params[:delivery_order_id])
    delivery_order.cancel(current_user.email)
    if delivery_order.save
      redirect_to :back
    else
      head :status => :unprocessable_entity
    end
  end
end