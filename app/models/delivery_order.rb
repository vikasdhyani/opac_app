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

  belongs_to :branch
  belongs_to :title
  belongs_to :ibtr

  def ready_for_processing?
    pickup? or ibtr.in_warehouse?
  end
end
