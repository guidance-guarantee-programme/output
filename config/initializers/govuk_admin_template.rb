GovukAdminTemplate.environment_style = Rails.env.staging? ? 'preview' : ENV['RAILS_ENV'] # rubocop:disable Rails/UnknownEnv
GovukAdminTemplate.environment_label = Rails.env.titleize
