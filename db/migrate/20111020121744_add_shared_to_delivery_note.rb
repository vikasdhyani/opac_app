class AddSharedToDeliveryNote < ActiveRecord::Migration
  def self.up
    add_column :delivery_notes, :shared, :boolean
  end

  def self.down
    remove_column :delivery_notes, :shared
  end
end
