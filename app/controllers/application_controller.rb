class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!

  def authenticate_admin_user!
    if current_user.nil?
      redirect_to root_url
      return
    end

    redirect_to root_url unless current_user.strata_employee?
  end
end
