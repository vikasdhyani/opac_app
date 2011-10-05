class DeliveryOrder < ActiveRecord::Base
  # Delivery Order Status
  PENDING = "P"
  DONE = "D"

  #Delivery Types
  DELIVERY = "D"
  PICKUP = "P"

  scope :live_orders, lambda { where(:status => PENDING) }
  delegate :in_warehouse?, :to => :ibtr

  def pickup?
   order_type == PICKUP
  end

  # Disallow all updates
  before_update { false }

  belongs_to :branch
  belongs_to :title
  belongs_to :ibtr
end
