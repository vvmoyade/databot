class Profile < ActiveRecord::Base
    belongs_to :mywebsite
    belongs_to :scheduler
    accepts_nested_attributes_for :scheduler

    def next_sending_time
        parsed_time = Time.parse("#{hours}:#{minutes}") 
        if scheduler_id == 1 #'daily'
            parsed_time + 1.day
        else
            1.week.from_now(Time.parse("#{hours}:#{minutes}"))
        end
    end

    def schedule_date
        if scheduler_id ==1
          {:start_date => Date.today-1, :end_date => Date.today}
        else
          {:start_date => Date.today-6,:end_date => Date.today}
        end
      end

      def metric_type
         (scheduler_id ==1)? "day" : "week"
      end
end
