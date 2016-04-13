require 'warden/test/helpers'

module GdsSso
  include Warden::Test::Helpers

  def login_as(user)
    GDS::SSO.test_user = user
  end

  def log_out
    GDS::SSO.test_user = nil
  end
end

World(GdsSso)

After('@signon') do
  log_out
  Warden.test_reset!
end
