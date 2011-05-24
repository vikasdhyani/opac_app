class AddUserstampToIbtr < ActiveRecord::Migration
  def self.up
    add_column :ibtrs, :created_by, :integer
    add_column :ibtrs, :modified_by, :integer
  end

  def self.down
    remove_column :ibtrs, :created_by
    remove_column :ibtrs, :modified_by
  end
end
