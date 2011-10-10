class CreateDeliverySchedules < ActiveRecord::Migration
  def self.up
    create_table :delivery_schedules do |t|
      t.date :delivery_date
      t.integer :delivery_slot_id

      t.timestamps
    end
  end

  def self.down
    drop_table :delivery_schedules
  end
end
