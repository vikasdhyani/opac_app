class CreateBookCorrections < ActiveRecord::Migration
  def self.up
    create_table :book_corrections do |t|
      t.string :old_isbn
      t.string :new_isbn
      t.string :source
      t.integer :old_title_id
      t.integer :new_title_id
      t.integer :created_by
      t.string :state
      t.timestamps
    end
  end

  def self.down
    drop_table :book_corrections
  end
end
