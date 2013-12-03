class UserMailer < ActionMailer::Base
  helper :application
  
  default from: ApplicationHelper::MAILER_FROM_ADDRESS
  
  def comment_email(category, comment)
    @category = category
    @comment = comment
    
    mail(:to => ApplicationHelper::HUDACARD_ADMIN, :subject => "Hudacard contact form - #{@category}")
  end
end
