class BookCorrection < ActiveRecord::Base
  scope :pending_correction, where(:source => 'OTHER').joins("JOIN books on books.title_id = book_corrections.old_title_id")
  
  def self.record book, isbn, title_id, flg_jb_or_other, params
      book_correction = BookCorrection.new
      book_correction.old_isbn = book.isbn_was
      book_correction.old_title_id = book.title_id_was
      book_correction.book_no = book.book_no
      book_correction.new_isbn = isbn
      book_correction.new_title_id = title_id
      book_correction.source = flg_jb_or_other
      book_correction.state = :New
      book_correction.created_by = book.updated_by
      
      #From Flipkart
    unless params.nil?
      book_correction.title = params[:title]
      book_correction.authors = params[:authors]
      book_correction.publisher = params[:publisher]
      book_correction.image = params[:image]
      book_correction.pubdate = params[:pubdate]
      book_correction.format = params[:format]
      book_correction.page_cnt = params[:page_cnt]
      book_correction.lang = params[:language]
    end
    
      book_correction.save
  end
end
