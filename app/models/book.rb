
class Book < ActiveRecord::Base

  
  JB_OTHER = {
    :jb   => 'JB',
    :other  => 'OTHER'
  }  

  belongs_to :title
  belongs_to :branch
  belongs_to :catalogued_branch, :class_name => 'Branch', :foreign_key => 'catalogued_branch_id'
  attr_accessor :flg_jb_or_other
  validates  :title_id, :presence => true
  validates  :isbn, :presence => true

  validate :isbn_is_diff
  before_validation :set_data

  def isbn_is_diff
    if !self.isbn_changed?
      errors.add(:book_no, ' ISBN is same')
    end
  end
  
  def set_data
    if flg_jb_or_other.eql?(Book::JB_OTHER[:other])
      self.title_id = self.title_id_was
    end
  end
end
