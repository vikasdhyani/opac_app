class DeliveryOrder < ActiveRecord::Base

  DELIVERY_ORDER_STATUS = [
    PENDING = "P",
    DONE = "D"
  ]

  DELIVERY_TYPES = [
    DELIVERY = "D",
    PICKUP = "P"
  ]

  scope :live_orders, lambda { where(:status => PENDING) }
  scope :overdue_orders, lambda { live_orders.includes(:delivery_schedule).where("delivery_schedules.delivery_date < ?", Date.today) }

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
