class Mywebsite < ActiveRecord::Base
  belongs_to :user
  has_one :profile

  def get_profile
    $profiles.detect{|profile| JSON.parse(profile.to_json)["entry"]["websiteUrl"]==self.website_url}
  end
end
