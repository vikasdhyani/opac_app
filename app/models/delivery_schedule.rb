class DeliverySchedule < ActiveRecord::Base
  belongs_to :delivery_slot
  validates_presence_of :delivery_date
  validates_presence_of :delivery_slot_id
  validates_uniqueness_of :delivery_date, :scope => :delivery_slot_id
  has_many :delivery_orders

  def add_delivery_orders_by_id(delivery_orders)
    orders = DeliveryOrder.find(delivery_orders)
    self.delivery_orders += orders
  end
end