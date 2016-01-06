class AnalyticsMailer < Devise::Mailer   
  default :from => "noreply@myhost.com"
  default template_path: 'users/mailer' # to make sure that your mailer uses the devise views

  def send_email(resource,metric_info,dimension_info,url,metric_type)
    @user = resource 
    @info = metric_info
    @dimension_info = dimension_info
    @url = url
    @metric_type = metric_type
    mail(:to => resource.email, :subject => "Databot Websites Data",:from => "noreply@databot.com")
  end
end