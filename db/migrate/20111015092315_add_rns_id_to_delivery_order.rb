class AddRnsIdToDeliveryOrder < ActiveRecord::Migration
  def self.up
    add_column :delivery_orders, :rns_id, :integer
  end

  def self.down
    remove_column :delivery_orders, :rns_id
  end
end
