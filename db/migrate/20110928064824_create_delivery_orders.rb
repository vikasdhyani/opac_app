class CreateDeliveryOrders < ActiveRecord::Migration
  def self.up
    create_table :delivery_orders do |t|
      t.string :membership_no
      t.integer :title_id
      t.integer :ibt_requestid
      t.string :status
      t.integer :branch_id
      t.string :created_by
      t.string :order_type

      t.timestamps
    end
  end

  def self.down
    drop_table :delivery_orders
  end
end
