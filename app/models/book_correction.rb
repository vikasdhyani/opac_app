class BookCorrection < ActiveRecord::Base
  def self.record book, isbn, title_id, flg_jb_or_other
      book_correction = BookCorrection.new
      book_correction.old_isbn = book.isbn_was
      book_correction.old_title_id = book.title_id_was
      book_correction.book_no = book.book_no
      book_correction.new_isbn = isbn
      book_correction.new_title_id = title_id
      book_correction.source = flg_jb_or_other
      book_correction.state = :New
      book_correction.created_by = book.updated_by
      book_correction.save
  end
end
