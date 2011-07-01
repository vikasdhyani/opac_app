class CreateFranchises < ActiveRecord::Migration
  def self.up
    create_table :franchises do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :franchises
  end
end
