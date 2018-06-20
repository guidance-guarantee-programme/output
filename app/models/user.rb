class User < ApplicationRecord
  include GDS::SSO::User
  serialize :permissions, Array

  TELEPHONE_APPOINTMENT_PERMISSION = 'phone_bookings'.freeze
  FACE_TO_FACE_PERMISSION = 'face_to_face_bookings'.freeze

  deprecated_columns :admin, :first_name, :last_name, :encrypted_password, :sign_in_count, :current_sign_in_at,
                     :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip, :confirmation_token, :confirmed_at,
                     :confirmation_sent_at, :unconfirmed_email, :failed_attempts, :unlock_token, :locked_at,
                     :organisation, :invitation_token, :invitation_created_at, :invitation_sent_at,
                     :invitation_accepted_at, :invitation_limit, :invited_by_id, :invited_by_type, :invitations_count,
                     :first_name, :last_name, :reset_password_token, :reset_password_sent_at, :role

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
