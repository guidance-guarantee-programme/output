# frozen_string_literal: true
class UserAdminCli
  def admins
    User.admins.map { |u| "#{u.name} <#{u.email}>" }
  end

  def team_leaders
    User.team_leaders.map { |u| "#{u.name} <#{u.email}>" }
  end

  def toggle_admin(email)
    toggle(email, User::ADMIN)
  end

  def toggle_team_leader(email)
    toggle(email, User::TEAM_LEADER)
  end

  private

  def toggle(email, role)
    return unless email.present?

    User.find_by(email: email).tap do |u|
      u&.toggle_role(role)
    end
  end
end
