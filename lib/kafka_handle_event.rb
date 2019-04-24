require 'kafka_handle_event/config'
require 'kafka_handle_event/event_proxy'
require 'kafka_handle_event/event_handler'
require 'active_support/all'

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
      message = message.with_indifferent_access
      topic_name = message[:topic_type]
      event_proxies = @registry.values.select { |proxy| proxy.topics.include?(topic_name) }
      event_proxies.each do |event_proxy|
        KafkaHandleEvent::EventHandler.new(event_proxy, message).handle_event
      end
    end
  end
end
