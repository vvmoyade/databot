class ApplicationController < ActionController::Base
  include HomeHelper  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected  

  def verify_profiles
      # Reload profile auth
      load_user_profiles if $profiles.blank?
  end

  def set_date
    if params[:metric_type] == "day"
      {:start_date => Date.today-1, :end_date => Date.today}
    else
      {:start_date => Date.today-6,:end_date => Date.today}
    end
  end

  def set_metrics
    params[:profile].collect{|key,value| [key.to_sym] if value=="1"}.compact rescue all_metrics
  end

  def get_access_token
    response = RestClient.get("https://slack.com/api/oauth.access?client_id=4562688944.17099089637&client_secret=4b4ce916f1c49fe1358b83bd7e0c861c&code=#{params[:code]}") 
    json_response = JSON.parse(response)
    current_user.update_attributes({:slack_token=> json_response["access_token"],:slack_url=>json_response["incoming_webhook"]["url"],:slack_channel=>json_response["incoming_webhook"]["channel"]})
  end  
end
