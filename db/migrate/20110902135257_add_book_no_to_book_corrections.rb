class AddBookNoToBookCorrections < ActiveRecord::Migration
  def self.up
    add_column :book_corrections, :book_no, :integer
  end

  def self.down
    remove_column :book_corrections, :book_no
  end
end
