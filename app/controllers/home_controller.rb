class HomeController < ApplicationController
    include HomeHelper  
    helper_method :get_bot_message
    before_filter :verify_profiles,:only=>[:send_daily_summary,:send_weekly_summary,:get_profile_metrics]

    def index
        if current_user
            #redirect_to oauth_authorize_path
        end
    end

    def send_daily_summary
        # Called for default #all metrics mention below
        profile = get_profile(params[:profile])
        url = JSON.parse(profile.to_json)["entry"]["websiteUrl"]
        metric_results,dimension_results = send_metrics(profile, set_date, all_metrics)
        message_hash = get_bot_message(metric_results, dimension_results, url, params[:metric_type])
        send_summary_through_bot(message_hash, url, params[:metric_type])
        #AnalyticsMailer.send_email(current_user,metric_results,dimension_results,url,params[:metric_type]).deliver_now
        render json: {message: "Message Posted by bolt to #{current_user.slack_channel} channel"}
    end
end
