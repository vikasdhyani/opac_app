require "spec_helper"

describe ApplicationController do

  it "should not redirect if the current user is a strata employee" do
    controller.stub!(:current_user).and_return(stub(:strata_employee? => true))
    controller.should_receive(:redirect_to).never
    controller.authenticate_admin_user!
  end

  it "should redirect to root if the user is not strata employee" do
    controller.stub!(:current_user).and_return(stub(:strata_employee? => false))
    controller.should_receive(:redirect_to).with(root_url)
    controller.authenticate_admin_user!
  end

  it "should redirect to root if the user is not logged in" do
    controller.stub!(:current_user).and_return(nil)
    controller.should_receive(:redirect_to).with(root_url)
    controller.authenticate_admin_user!
  end
end