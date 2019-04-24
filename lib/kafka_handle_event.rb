require 'kafka_handle_event/config'

module KafkaHandleEvent
  class << self
    def configure
      yield(config)
    end

    def config
      @config ||= Config.new
    end
  end
end
