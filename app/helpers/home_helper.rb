module HomeHelper
  def get_bot_message(info, dimension_info, url, metric_type)
    message = ""
    message = message << "(Week of #{Date.today.beginning_of_week.strftime('%d/%m/%Y')})\n" if metric_type=="week"
    message_hash = Hash.new
    info.flatten.map(&:results).each do |metric|
      day_before_metrics = metric.first
      metrics_today = metric.second
      message_hash["Pageviews"] = [day_before_metrics.pageviews, metrics_today.pageviews] if !metrics_today.pageviews.nil?
      message_hash["New Users"] = [day_before_metrics.new_users, metrics_today.new_users] if !metrics_today.new_users.nil?
      message_hash["Users"] = [day_before_metrics.users, metrics_today.users] if !metrics_today.users.nil?
      message_hash["Sessions"] = [day_before_metrics.sessions, metrics_today.sessions] if !metrics_today.sessions.nil?
      message_hash["Average Seconds Session Duration"] = [day_before_metrics.avg_session_duration, metrics_today.avg_session_duration] if !metrics_today.avg_session_duration.nil?
    end
    message_hash
  end
  
  def handle_values(key, val_1, val_2, metric_type)
    output = ""
    if key != "Average Seconds Session Duration"
      output = (val_2.to_i - val_1.to_i == 0) ? "Even to the #{metric_type} before" : (val_2.to_i - val_1.to_i < 0 ? 
        "▼ #{(val_2.to_i - val_1.to_i).abs} from the #{metric_type} before" : "▲ #{(val_2.to_i - val_1.to_i).abs} from the #{metric_type} before")
    else
      output = (val_2.to_i - val_1.to_i == 0) ? "Even to the #{metric_type} before" : (val_2.to_i - val_1.to_i < 0 ? 
        "▼ #{(val_2.to_f.ceil - val_1.to_f.ceil).abs} from the #{metric_type} before" : "▲ #{(val_2.to_f.ceil - val_1.to_f.ceil).abs} from the #{metric_type} before")
    end
    output
  end

  def send_summary_through_bot(message_hash, website_url, metric_type,user=current_user)
    url = user.slack_url
    initheader = { 'Content-Type' => 'application/json'}
    field = []
    message_hash.each do |key, values|
      puts "values "
      title = key == "Average Seconds Session Duration" ? values[1].to_f.ceil.to_s + " " + key : values[1] + " " + key 
      field.push({"title": title, "value": handle_values(key, values[0], values[1], metric_type), "short": true})
    end
    payload = {"channel": "#{user.slack_channel}", "username": "vijayshree_databot", 
        "attachments": [
          { "color": "#88D8BF", 
            "title": "GA summary for #{website_url}", 
            "fields": field
          }
        ]
      
    }
    encoded = JSON.generate(payload)
    response = RestClient.post(url, encoded, initheader)
  end

  def set_schedule_options
    [["Enable daily summary",1],["Enable weekly summary",2]]
  end

  def initialize_user_auth(user=current_user) # To make it user accessible in rescue task simultaneously
      # Re-use consumer auth for reloading analytics profiles 
      $consumer = OAuth::Consumer.new("673626857693-op0dkv412hd8png47jtt1c8ruktdg258.apps.googleusercontent.com","7ddGAyHJkpH-eDop7xt40w7X", {
      :site => 'http://localhost:3000',
      :request_token_path => '/accounts/OAuthGetRequestToken',
      :access_token_path => '/accounts/OAuthGetAccessToken',
      :authorize_path => '/accounts/OAuthAuthorizeToken'
      }) rescue ''
  end

  def load_user_profiles(user=current_user)
      initialize_user_auth(user)
      begin
          garbsession = Garb::Session.new
          garbsession.access_token = OAuth::AccessToken.new($consumer, user.google_token, user.google_secret)
          # Once we have an OAuth::AccessToken constructed, do fun stuff with it
          $profiles = Garb::Management::Profile.all(garbsession)
          $profiles
      rescue
      end
  end

  def create_report metrics, dimensions
    # Create report with dynamic set of metrics 
    report = Report
    report.metrics.reset metrics
    report.dimensions.reset dimensions
    report
  end

  def send_metrics(profile, dimension_value, default_metric, default_dimension=[:date])
      #,[:goalXXConversionRate] not working
      metric_result=[], dimension_result = []
        default_metric.each do |metric|
          report = create_report(metric, default_dimension)
          puts 'report is ', report.results(profile, dimension_value).inspect
          begin
            metric_result << report.results(profile, dimension_value) # In filter we send only dimension value not metric     
          rescue 
            next   
          end       
        end

        # Fetch source and top landing page
        report = create_report([:users], [:source, :date])
        dimension_result << report.results(profile, :dimensions=>':source, :landingPagePath')
      return metric_result, dimension_result
  end

  def get_profile(profile_id)
      $profiles.detect{|profile| profile.id==profile_id}
  end

  def all_metrics
    [[:pageviews],[:newUsers,:users],[:avgSessionDuration,:sessions],[:totalEvents]] 
  end
end
