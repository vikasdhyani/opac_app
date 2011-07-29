require 'mechanize'
require File.expand_path('../../../config/flipkart_info.rb', __FILE__)

class BooksController < ApplicationController

  def search
  end
  def result
    id = params[:search][:book_no]
    redirect_to book_path(id)
  end
  
  def show
    book_no = params[:id]
    @book = Book.find(book_no) unless book_no.nil?
  end
  
  def edit
    @book = Book.find(params[:id])
  end
  def isbn
    book_no = params[:search][:book_no]
    isbn = params[:search][:isbn]
    @book = Book.find(book_no) unless book_no.nil?
    @enrichedtitle = Enrichedtitle.find_by_isbn(isbn) unless isbn.nil?
    @flipkart_info = nil
    if (@enrichedtitle.nil?)
      @flipkart_info = FlipkartInfo.book_info(isbn)
      @flipkart_info[:isbn] = isbn unless  @flipkart_info.nil?
    end
  end
  
  def update
    @book = Book.find(params[:id])
    book_correction = BookCorrection.new(:old_isbn => @book.isbn, :old_title_id => @book.title_id)
    if @book.update_attributes( params[:book])
      book_correction.new_isbn = @book.isbn
      book_correction.new_title_id = @book.title_id
      book_correction.source = @book.flg_jb_or_other
      book_correction.state = :New
      book_correction.created_by = current_user.id
      book_correction.save!
      redirect_to(@book, :notice => 'Book was successfully updated.') 
    else
       render :action => "edit"

    end
    
  end
  
  def mail
    book_no = params[:id]
    @book = Book.find(book_no)
    user = current_user
    BookMailer.isbn_not_found(@book, user).deliver
    redirect_to(@book, :notice => 'Mail sent to tech support.') 
  end
end
