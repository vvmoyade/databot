class ProfilesController < ApplicationController
    include HomeHelper 
    before_action :set_profile, only: [:index, :edit, :update]
    before_action :verify_profiles,only:[:update]
    # GET /profiles/1/edit

    def index
        get_access_token if params.include? :code
        load_user_profiles
        redirect_to edit_profile_path(@profile)
    end

    def edit
      load_user_profiles      
    end

    def update
        #AnalyticsMailer.send_email(current_user,metric_results,dimension_results,url,params[:metric_type]).deliver_now
        respond_to do |format|
            if @profile.update(profile_params)
                Resque.enqueue(Schedule,@profile.id)
                format.json { render json: {message: "Profile saved successfully"}, status: :ok, location: @profile }
            else
                format.json { render json: @profile.errors, status: :unprocessable_entity }
            end
        end
    end

    private
        # # Use callbacks to share common setup or constraints between actions.
    def set_profile
        @profile = Profile.find(session[:profile_id])
    end

    # # Never trust parameters from the scary internet, only allow the white list through.
    def profile_params
        params.require(:profile).permit(:profile_index, :name, :users, :newUsers, :conversions, :pageviews, :avgSessionDuration, :totalEvents, :sessions, :mywebsite_id,:hours,:minutes,scheduler_attributes:[:id])
    end
end
