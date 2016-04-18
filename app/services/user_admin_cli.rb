# frozen_string_literal: true
class UserAdminCli
  def admins
    User.admins.map { |u| "#{u.name} <#{u.email}>" }
  end

  def toggle(email)
    return unless email.present?

    User.find_by(email: email).tap do |u|
      u&.toggle!(:admin)
    end
  end
end
