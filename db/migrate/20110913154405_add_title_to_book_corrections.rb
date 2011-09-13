class AddTitleToBookCorrections < ActiveRecord::Migration
  def self.up
    add_column :book_corrections, :title, :string
    add_column :book_corrections, :authors, :string
    add_column :book_corrections, :publisher, :string
    add_column :book_corrections, :image, :string
    add_column :book_corrections, :pubdate, :string
    add_column :book_corrections, :format, :string
    add_column :book_corrections, :page_cnt, :string
    add_column :book_corrections, :lang, :string
  end

  def self.down
    remove_column :book_corrections, :lang
    remove_column :book_corrections, :page_cnt
    remove_column :book_corrections, :format
    remove_column :book_corrections, :pubdate
    remove_column :book_corrections, :image
    remove_column :book_corrections, :publisher
    remove_column :book_corrections, :authors
    remove_column :book_corrections, :title
  end
end
