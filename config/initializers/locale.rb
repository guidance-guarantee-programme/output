# frozen_string_literal: true
Rails.application.configure do
  # We only need to make the following available
  config.i18n.available_locales = ['en-GB', :en]

  # Default to British English
  config.i18n.default_locale = 'en-GB'

  # Use English if a British English translation is missing
  config.i18n.fallbacks = true
  config.i18n.fallbacks = %i(en)
end
