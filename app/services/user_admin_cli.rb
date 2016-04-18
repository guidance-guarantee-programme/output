# frozen_string_literal: true
class UserAdminCli
  def admins
    User.admins.map { |u| "#{u.name} <#{u.email}>" }
  end
end
