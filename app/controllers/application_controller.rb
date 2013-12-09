class ApplicationController < ActionController::Base
  protect_from_forgery
  include SimpleCaptcha::ControllerHelpers
  
  # If logging in as an admin, go to the admin dashboard (currently the pending transactions queue)
  def after_sign_in_path_for(resource)
    if resource.admin?
      btc_transactions_path
    else
      root_path
    end
  end 
  
  rescue_from CanCan::AccessDenied do |exception|
      redirect_to main_app.root_path, :alert => exception.message
  end
end
