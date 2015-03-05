class User < ActiveRecord::Base
  devise :database_authenticatable, :confirmable, :lockable, :timeoutable, :trackable, :validatable

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end
end
