class DeliveryOrder < ActiveRecord::Base
  # Delivery Order Status
  PENDING = "P"
  DONE = "D"

  #Delivery Types
  DELIVERY = "D"
  PICKUP = "P"

  scope :live_orders, lambda { where(:status => PENDING) }

  def pickup?
   order_type == PICKUP
  end

  # Disallow all updates
  before_update { false }
end
