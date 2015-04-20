module TaggedLogger
  class << self
    attr_accessor :logger
  end

  %i(debug info warn error fatal).each do |level|
    define_method(level) do |message|
      TaggedLogger.logger.public_send(level, "[#{self.class}] #{message}")
    end
  end
end
