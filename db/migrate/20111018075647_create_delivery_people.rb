class CreateDeliveryPeople < ActiveRecord::Migration
  def self.up
    create_table :delivery_people do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :delivery_people
  end
end
