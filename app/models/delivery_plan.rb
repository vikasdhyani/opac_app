class DeliveryPlan
  attr_reader :dates

  def initialize(start_date = Date.today, end_date = start_date + 6.days)
    @dates = start_date.step(end_date, 1.day).to_a
  end

  def deliveries_on(delivery_date, delivery_slot)
    delivery_schedule = DeliverySchedule.find_by_delivery_date_and_delivery_slot_id(delivery_date, delivery_slot) || DeliverySchedule.new
    delivery_schedule.delivery_orders
  end

  def slots
    DeliverySlot.all
  end
end