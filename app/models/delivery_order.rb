class DeliveryOrder < ActiveRecord::Base
  # Delivery Order Status
  PENDING = "P"
  DONE = "D"

  #Delivery Types
  DELIVERY = "D"
  PICKUP = "P"

  scope :live_orders, lambda { where(:status => PENDING) }

  delegate :delivery_date, :delivery_slot, :to => :delivery_schedule

  def pickup?
   order_type == PICKUP
  end

  belongs_to :title
  belongs_to :ibtr
  belongs_to :delivery_schedule
  has_many   :delivery_notes

  def ready_for_processing?
    pickup? or ibtr.in_warehouse?
  end

  def scheduled?
    not delivery_schedule_id.nil?
  end
end
