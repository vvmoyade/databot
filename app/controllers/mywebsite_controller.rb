class MywebsiteController < ApplicationController
    before_filter :verify_user_auth,:only=>[:new,:create]

    def new 
        @mywebsite = Mywebsite.new
    end

    def create
        @mywebsite = Mywebsite.find_or_create_by(mywebsite_params.merge({:user_id=>current_user.id}))
         profile = @mywebsite.get_profile
         @mywebsite.create_profile({:profile_index=> profile.id}) if @mywebsite.profile.blank?
         session[:profile_id]= @mywebsite.profile.id
        (redirect_to root_url and return) if !@mywebsite.save
        redirect_to profiles_url if current_user.slack_token
    end

private

    def mywebsite_params
        params.require(:mywebsite).permit(:website_url)
    end

    def verify_user_auth
        unless(current_user.google_token && load_user_profiles)
            reset_session
            flash.keep
            flash[:notice]="Something went wrong. Please make sure you have google analytics account"
            redirect_to root_url
        end
    end
end
