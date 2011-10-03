class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
end

class ActionController::Base
  def authenticate_admin_user!
  end
end
