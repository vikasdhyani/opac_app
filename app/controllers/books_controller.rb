require 'mechanize'
require File.expand_path('../../../config/flipkart_info.rb', __FILE__)

class BooksController < ApplicationController

  def search
  end
  def result
    id = params[:search][:book_no].gsub(/[a-zA-Z]/,'')
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
    @isbn = isbn
    if (@enrichedtitle.nil?)
      @flipkart_info = FlipkartInfo.book_info(isbn)
      @flipkart_info[:isbn] = isbn unless  @flipkart_info.nil?
    end
  end
  
  def update
    @book = Book.find(params[:id])
    @book.updated_by = current_user.id
    if (params[:book][:flg_jb_or_other] == Book::JB_OTHER[:jb] && @book.update_attributes(params[:book])) || (BookCorrection.record(@book, params[:book][:isbn], 0, params[:book][:flg_jb_or_other]))
      redirect_to(@book, :notice => 'Book was successfully updated.') 
    else
      #Revert to old values/discard changes, so that new image is not shown
      @book.isbn = @book.isbn_was
      @book.title_id = @book.title_id_was
      render :action => "edit"
    end    
  end
  
  def mail
    book_no = params[:id]
    isbn = params[:isbn]
    @book = Book.find(book_no)
    user = current_user
    BookMailer.isbn_not_found(@book, user, isbn).deliver
    redirect_to(@book, :notice => 'Mail sent to tech support.') 
  end
end
