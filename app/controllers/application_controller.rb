# frozen_string_literal: true
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include GDS::SSO::ControllerMethods

  if ENV['AUTH_USERNAME'] && ENV['AUTH_PASSWORD']
    http_basic_authenticate_with name: ENV['AUTH_USERNAME'], password: ENV['AUTH_PASSWORD']
  end

  private

  def authenticate_as_team_leader!
    authorise_user!('team_leader')
  rescue PermissionDeniedException
    redirect_to root_path
  end

  def authenticate_as_analyst!
    authorise_user!('analyst')
  rescue PermissionDeniedException
    redirect_to root_path
  end
end
