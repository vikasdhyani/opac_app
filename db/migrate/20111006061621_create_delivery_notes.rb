class CreateDeliveryNotes < ActiveRecord::Migration
  def self.up
    create_table :delivery_notes do |t|
      t.string :content
      t.integer :delivery_order_id

      t.timestamps
    end
  end

  def self.down
    drop_table :delivery_notes
  end
end
