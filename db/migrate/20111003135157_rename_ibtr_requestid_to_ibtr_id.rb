class RenameIbtrRequestidToIbtrId < ActiveRecord::Migration
  def self.up
    rename_column :delivery_orders, :ibt_requestid, :ibtr_id
  end

  def self.down
    rename_column :delivery_orders, :ibtr_id, :ibt_requestid
  end
end
