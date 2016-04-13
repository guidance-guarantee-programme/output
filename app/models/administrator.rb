class Administrator < ActiveRecord::Base
  include GDS::SSO::User

  serialize :permissions, Array
end
