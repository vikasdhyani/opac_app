class CreateDeliveryPersonAllotments < ActiveRecord::Migration
  def self.up
    create_table :delivery_person_allotments do |t|
      t.string :membership_no
      t.integer :delivery_schedule_id
      t.integer :delivery_person_id

      t.timestamps
    end
  end

  def self.down
    drop_table :delivery_person_allotments
  end
end
