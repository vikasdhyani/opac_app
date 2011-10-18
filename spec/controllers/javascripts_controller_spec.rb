require 'spec_helper'

describe JavascriptsController do
  before(:each) { sign_in Factory(:user) }

  render_views

  it "gets the path helper with correct paths" do
    get :path_helpers
    response.should be_success
  end
end
