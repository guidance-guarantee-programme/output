# frozen_string_literal: true
class DeviseTaggedLogging
  def initialize(app)
    @app = app
  end

  def call(env)
    if logger.respond_to?(:tagged)
      logger.tagged(devise_tags(env)) { @app.call(env) }
    else
      @app.call(env)
    end
  end

  private

  def logger
    Rails.logger
  end

  def devise_tags(env)
    "uid: #{env['warden'].user.try(:id)}"
  end
end
