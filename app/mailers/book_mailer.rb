class BookMailer < ActionMailer::Base
  default :from => "mc@strataretail.co"
  
  
  def isbn_not_found(book, user)
    @book = book
    @user = user
    to_ids = 'tech.support@justbooksclc.com'
    
    mail(:to => to_ids,
         :subject => "Books ISBN not found")
  end
end
