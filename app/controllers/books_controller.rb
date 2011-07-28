require 'mechanize'
require File.expand_path('../../../config/flipkart_info.rb', __FILE__)

class BooksController < ApplicationController

  def search
    logger.info 'in search get'
  end

  def result
    logger.info 'in search post'
    book_no = params[:search][:book_no]
    isbn = params[:search][:isbn]
    logger.info 'book no is '+book_no
    @book = Book.find(book_no) unless book_no.nil?
    @enrichedtitle = Enrichedtitle.find_by_isbn(isbn) unless isbn.nil?
    
    @flipkart_info = FlipkartInfo.book_info(isbn)
    @flipkart_info[:isbn] = isbn unless  @flipkart_info.nil?

    render 'search'
  end
end
