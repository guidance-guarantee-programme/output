# frozen_string_literal: true
module ApplicationHelper
  def bootstrap_alert_class_for(flash_type)
    case flash_type.to_sym
    when :success
      'alert-success' # Green
    when :error
      'alert-danger' # Red
    when :alert
      'alert-warning' # Yellow
    when :notice
      'alert-info' # Blue
    else
      flash_type.to_s
    end
  end

  def error_messages_for(model)
    render partial: 'shared/errors', locals: { model: model }
  end

  def email_validation_data_attributes
    {
      api_key: 'pubkey-b37c931b1fcef90bf2d83b7cdfd6df39',
      api_host: Rails.env.test? ? 'http://localhost:9293' : nil
    }
  end
end
