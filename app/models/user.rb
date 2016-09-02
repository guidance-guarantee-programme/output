# frozen_string_literal: true
class User < ActiveRecord::Base
  deprecated_columns :admin

  class UnableToSetRole < StandardError; end

  ADMIN = 'admin'
  TEAM_LEADER = 'team_leader'

  devise :database_authenticatable, :confirmable, :invitable, :lockable, :timeoutable, :trackable,
         :validatable, :zxcvbnable, :recoverable

  has_many :appointment_summaries

  scope :admins, -> { where(role: ADMIN).order(:last_name, :first_name) }
  scope :team_leaders, -> { where(role: TEAM_LEADER).order(:last_name, :first_name) }

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  def name
    [first_name, last_name].join(' ').strip
  end

  def admin?
    role == ADMIN
  end

  def team_leader?
    role == TEAM_LEADER
  end

  def toggle_role(role_to_toggle)
    raise(UnableToSetRole, "User has existing role: #{role}") unless ['', role_to_toggle].include?(role)

    update_attributes(role: role.present? ? '' : role_to_toggle)
  end
end
