class OrderList
  attr_accessor :membership_no
  attr_accessor :orders

  def initialize(membership_no, orders)
    @membership_no = membership_no
    @orders = orders
  end

  def number_of_pickups
    pickup_orders = orders.select(&:pickup?).size
  end

  def member
    @member ||= Membership.find_by_card_id(membership_no)
  end

  def self.sorted_by_number_of_orders
    all_orders = DeliveryOrder.live_orders.all
    orderlists = all_orders.group_by(&:membership_no).collect { |membership_no, orders| OrderList.new(membership_no, orders) }
    orderlists.sort { |list1, list2| list2.orders.size <=> list1.orders.size }
  end
end
