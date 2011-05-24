class AddUserstampToIbtrVersions < ActiveRecord::Migration
  def self.up
    add_column :ibtr_versions, :created_by, :integer
    add_column :ibtr_versions, :modified_by, :integer
  end

  def self.down
    remove_column :ibtr_versions, :created_by
    remove_column :ibtr_versions, :modified_by  
  end
end
