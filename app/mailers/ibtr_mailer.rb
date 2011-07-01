class IbtrMailer < ActionMailer::Base
  default :from => "mc@strataretail.co"
  
  def cancelled_notification(ibtr)
    @url = "http://example.com"
    mail(:to => 'akhilesh.kataria@strata.co.in',
         :subject => "This comes from rails")
  end
  
  def consignment_pickup_advice(id)
    @consignment = Consignment.find(id)
    to_ids = @consignment.origin.owner.nil? ? [] : @consignment.origin.owner.email.split(';')
    to_ids << @consignment.origin.email
    mail(:to => to_ids,
         #:cc => 'events@justbooksclc.com',
         :subject => "Consignment pickup advice")
  end
end
