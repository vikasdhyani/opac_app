require 'spec_helper'

describe PrintableReportsController do
  before(:each) do
    sign_in Factory(:user, :email => "foo@bar.com")
  end

  context "GET show" do
    it "should save the presenter" do
      slot = Factory(:delivery_slot)
      get :show, :delivery_date => "2010/02/02"
      response.should be_success
      assigns[:printable_report_presenter].slots.should == [slot]
    end
  end
end
