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

  belongs_to :title
  belongs_to :ibtr
  has_many   :delivery_notes

  def ready_for_processing?
    pickup? or ibtr.in_warehouse?
  end
end
