json.array!(@profiles) do |profile|
  json.extract! profile, :id, :profile_index, :name, :users, :newUsers, :conversions, :pageviews, :avgSessionDuration, :totalEvents, :sessions, :mywebsite_id
  json.url profile_url(profile, format: :json)
end
