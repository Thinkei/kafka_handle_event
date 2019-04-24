require 'kafka_handle_event/config'
require 'kafka_handle_event/event_proxy'

module KafkaHandleEvent
  @registry = {}

  class << self
    def configure
      yield(config)
    end

    def config
      @config ||= Config.new
    end

    def register(model_name, &block)
      event_proxy = EventProxy.new(model_name)
      event_proxy.instance_eval(&block)
      @registry[model_name] = event_proxy
    end

    def topics
      @registry.values.map(&:topics).flatten
    end

    def handle_event(message)
    end

    private
  end
end
