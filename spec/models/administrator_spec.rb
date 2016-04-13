require 'gds-sso/lint/user_spec'

RSpec.describe Administrator, type: :model do
  it_behaves_like 'a gds-sso user class'
end
