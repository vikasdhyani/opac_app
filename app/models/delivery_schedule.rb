class DeliverySchedule < ActiveRecord::Base
  MAX_ORDERS_PER_SLOT = 30

  belongs_to :delivery_slot
  has_many :delivery_orders

  validates_presence_of :delivery_date
  validates_presence_of :delivery_slot_id
  validates_uniqueness_of :delivery_date, :scope => :delivery_slot_id
  validate :max_delivery_order_limit

  def add_delivery_orders_by_id(delivery_orders)
    orders = DeliveryOrder.find(delivery_orders)
    self.delivery_orders += orders
  end

  def members_count
    delivery_orders.count(:membership_no, :distinct => true)
  end

  private
  def max_delivery_order_limit
   if (members_count > MAX_ORDERS_PER_SLOT)
     errors.add(:delivery_orders, "maximum order limit exceeded")
   end
  end
end