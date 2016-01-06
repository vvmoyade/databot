include HomeHelper 

class Schedule
      @queue = :simple

      def self.perform(profile_id)
        $my_profile = Profile.find profile_id
        Resque.remove_delayed(Schedule,$my_profile.profile_index)
        Resque.enqueue_at($my_profile.next_sending_time,Schedule.get_schedule,$my_profile.profile_index)
      end

      def self.get_schedule
        $my_user = Mywebsite.find($my_profile.mywebsite_id).user  
        auth_profiles = load_user_profiles($my_user)
        puts "ddd#{auth_profiles}"
        g_profile = auth_profiles.detect{|profile| profile.id==$my_profile.profile_index}
        puts "profile #{g_profile}"
        url = JSON.parse(g_profile.to_json)["entry"]["websiteUrl"]
        metric_results,dimension_results = send_metrics(g_profile, $my_profile.schedule_date, all_metrics)
        message_hash = get_bot_message(metric_results, dimension_results, url, $my_profile.metric_type)
        send_summary_through_bot(message_hash, url, $my_profile.metric_type,$my_user)
      end      
end