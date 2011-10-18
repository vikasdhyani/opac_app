class DeliverySchedule < ActiveRecord::Base
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

  class << self
    def by_date_and_slot_id(delivery_date, slot_id)
      find_or_initialize_by_delivery_date_and_delivery_slot_id(delivery_date, slot_id)
    end
  end

  private
  def max_delivery_order_limit
   errors.add(:delivery_orders, "cannot be more than #{OpacSettings.deliveries_per_slot} per slot") if members_count > OpacSettings.deliveries_per_slot
  end
end
