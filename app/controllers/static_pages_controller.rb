class StaticPagesController < ApplicationController
  def contact
    @categories = ['Question', 'Comment', 'Bug Report', 'Feature Request', 'Other']
  end
  
  def about
  end
  
  def account
  end
  
  def admin
    sign_out current_user unless current_user.nil?
    
    redirect_to new_user_session_path
  end
  
  def comment
    if simple_captcha_valid?  
      if params[:content].strip.blank?
        redirect_to contact_path, :alert => 'Please enter a comment'      
      else
        UserMailer.comment_email(params[:category], params[:email], params[:content]).deliver
        
        redirect_to root_path, :notice => 'Thanks for your comment!'
      end
    else
      redirect_to contact_path, :alert => 'Invalid Captcha; please try again!'
    end    
  end
end
