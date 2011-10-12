class DeliverySchedulePresenter
  attr_reader :dates

  def initialize(start_date = Date.today, end_date = start_date + 6.days)
    @dates = start_date.step(end_date, 1.day).to_a
  end

  def schedule_for(delivery_date, delivery_slot)
    DeliverySchedule.find_by_delivery_date_and_delivery_slot_id(delivery_date, delivery_slot) || DeliverySchedule.new
  end

  def deliveries_on(delivery_date, delivery_slot)
    schedule_for(delivery_date, delivery_slot).delivery_orders
  end

  def slots
    @slots ||= DeliverySlot.all
  end

  def members_count(delivery_date, delivery_slot)
    schedule_for(delivery_date, delivery_slot).members_count
  end
end