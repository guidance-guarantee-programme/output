class User < ApplicationRecord
  include GDS::SSO::User
  serialize :permissions, Array

  TELEPHONE_APPOINTMENT_PERMISSION = 'phone_bookings'.freeze
  FACE_TO_FACE_PERMISSION = 'face_to_face_bookings'.freeze
  API_USER_PERMISSION = 'api_user'.freeze

  has_many :appointment_summaries

  scope :admins, -> { where(role: ADMIN).order(:last_name, :first_name) }
  scope :team_leaders, -> { where(role: TEAM_LEADER).order(:last_name, :first_name) }

  def first_name
    name.split(' ').first
  end

  def team_leader?
    has_permission?('team_leader')
  end

  def analyst?
    has_permission?('analyst')
  end
end
