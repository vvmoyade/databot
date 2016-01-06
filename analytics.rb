
SERVICE_ACCOUNT_EMAIL_ADDRESS = '673626857693-compute@developer.gserviceaccount.com' # looks like 12345@developer.gserviceaccount.com
PATH_TO_KEY_FILE              = 'Databot-e16597551edf.p12' # the path to the downloaded .p12 key file
PROFILE                       = 'ga:83529218' # your GA profile id, looks like 'ga:12345'

require 'google/api_client'

# set up a client instance
client  = Google::APIClient.new

client.authorization = Signet::OAuth2::Client.new(
  :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
  :audience             => 'https://accounts.google.com/o/oauth2/token',
  :scope                => 'https://www.googleapis.com/auth/analytics.readonly',
  :issuer               => SERVICE_ACCOUNT_EMAIL_ADDRESS,
  :signing_key          => Google::APIClient::PKCS12.load_key(PATH_TO_KEY_FILE, 'notasecret')
).tap { |auth| auth.fetch_access_token! }

api_method = client.discovered_api('analytics','v3').data.ga.get


# make queries
result = client.execute(:api_method => api_method, :parameters => {
  'ids'        => PROILE,
  'start-date' => Date.new(1970,1,1).to_s,
  'end-date'   => Date.today.to_s,
  'dimensions' => 'ga:pagePath',
  'metrics'    => 'ga:pageviews'
})

puts result.data.rows.inspect