class PrintableReportPresenter
  def initialize(date)
    @date = date
  end

  def slots
    @slots ||= DeliverySlot.all
  end

  def delivery_people
    @delivery_people ||= DeliveryPerson.all
  end

  def order_lists_for(person, slot)
    delivery_schedule = DeliverySchedule.by_date_and_slot_id(@date, slot.id)
    OrderList.create_from_delivery_orders delivery_schedule.delivery_orders_for_delivery_person(person)
  end
end
