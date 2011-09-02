
class Book < ActiveRecord::Base
  attr_accessible :isbn, :title_id, :flg_jb_or_other
  
  JB_OTHER = {
    :jb   => 'JB',
    :other  => 'OTHER'
  }  

  belongs_to :title
  belongs_to :branch
  belongs_to :catalogued_branch, :class_name => 'Branch', :foreign_key => 'catalogued_branch_id'
  attr_accessor :flg_jb_or_other, :updated_by
  validates  :title_id, :presence => true
  validates  :isbn, :presence => true

  validate :isbn_is_diff_and_title_is_diff
  before_validation :set_data
  
  before_save :update_old_values
  after_save :record_book_correction

  def isbn_is_diff_and_title_is_diff
    if !self.isbn_changed?
      errors.add(:book_no, " ISBN is same #{self.isbn}  - #{self.isbn_was}")
    end
    if !self.title_id_changed?
      errors.add(:book_no, ' Title ID is Same')
    end
  end
  
  def set_data
    if flg_jb_or_other.eql?(Book::JB_OTHER[:other])
      self.title_id = self.title_id_was
    end
  end
  
  def update_old_values
    self.old_title_id = self.title_id_was
  end
  
  def record_book_correction
    if self.isbn_changed? or self.title_id_changed?
      BookCorrection.record(self,self.isbn,self.title_id,self.flg_jb_or_other)
    end
  end
end
