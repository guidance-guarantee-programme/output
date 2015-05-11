class User < ActiveRecord::Base
  devise :database_authenticatable, :confirmable, :invitable, :lockable, :timeoutable, :trackable,
         :validatable, :zxcvbnable, :recoverable

  has_many :appointment_summaries

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  def name
    [first_name, last_name].join(' ').strip
  end

  def first_name
    super || self[:name].try do |name|
      name.split(' ').first
    end
  end

  def last_name
    super || self[:name].try do |name|
      name.split(' ').last
    end
  end
end
