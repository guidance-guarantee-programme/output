GDS::SSO.config do |config|
  config.user_model = 'User'

  config.oauth_id = ENV['OAUTH_ID']
  config.oauth_root_url = ENV['OAUTH_ROOT_URL']
  config.oauth_secret = ENV['OAUTH_SECRET']

  config.additional_mock_permissions_required = ['api_user']

  config.cache = Rails.cache
end
