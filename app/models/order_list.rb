class OrderList
  include Comparable
  include Enumerable

  attr_accessor :membership_no
  attr_accessor :orders

  def initialize(membership_no, orders)
    @membership_no = membership_no
    @orders = orders
  end

  def number_of_pickups
    orders.select(&:pickup?).size
  end

  def member
    @member ||= Membership.find_by_card_id(membership_no)
  end

  delegate :name, :lphone, :mphone, :address, :to => :member

  def max_date
    orders.max_by(&:created_at).created_at
  end

  def at_least_one_item_ready?
    orders.any?(&:ready_for_processing?)
  end

  def <=>(other)
    return 1 unless self.at_least_one_item_ready?
    return -1 unless other.at_least_one_item_ready?
    other.max_date <=> self.max_date
  end

  def each
    @orders.each do |order|
      yield order
    end
  end

  def shared_notes
    @orders.inject([]){ |sum, order| sum + order.shared_notes }
  end

  class << self
    def create_from_delivery_orders(all_orders)
      order_lists = all_orders.group_by(&:membership_no).collect { |membership_no, orders| OrderList.new(membership_no, orders) }
      order_lists.sort!
    end

    def all(criteria = {})
      where_criteria = criteria.clone.delete_if { |k, v| v.empty? }
      all_orders = DeliveryOrder.live_orders.includes(:delivery_schedule).where(where_criteria)
      create_from_delivery_orders all_orders
    end

    def overdue_orders
      create_from_delivery_orders DeliveryOrder.overdue_orders
    end
  end
end
