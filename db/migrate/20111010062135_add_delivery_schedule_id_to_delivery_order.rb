class AddDeliveryScheduleIdToDeliveryOrder < ActiveRecord::Migration
  def self.up
    add_column :delivery_orders, :delivery_schedule_id, :integer
  end

  def self.down
    remove_column :delivery_orders, :delivery_schedule_id
  end
end
