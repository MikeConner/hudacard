class UserMailer < ActionMailer::Base
  helper :application
  
  default from: ApplicationHelper::MAILER_FROM_ADDRESS
  
  def comment_email(category, email, comment)
    @category = category
    @comment = comment
    @email = email.blank? ? 'Anonymous' : email
    
    mail(:to => ApplicationHelper::HUDACARD_ADMIN, :subject => "Hudacard contact form - #{@category}")
  end
end
