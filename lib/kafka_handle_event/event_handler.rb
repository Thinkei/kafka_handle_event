require 'kafka_handle_event/attribute_mapper'

module KafkaHandleEvent
  class EventHandler
    attr_accessor :proxy, :message

    def initialize(proxy, message)
      @proxy = proxy
      @message = message.with_indifferent_access
    end

    def handle_event
      case message[:event]
      when 'create'
        handle_create
      when 'update'
        handle_update
      when 'destroy'
        handle_destroy
      end
    end

    private

    ['create', 'update', 'destroy'].each do |type|
      define_method "handle_#{type}" do
        created_record = nil
        if proxy.model_class && proxy.public_send("do_#{type}_block").nil?
          created_record = self.send("default_do_#{type}")
        else
          raise "Need to setup do_#{type} on model #{proxy.model_name}" unless proxy.public_send("do_#{type}_block")
          created_record = proxy.public_send("do_#{type}_block").call(mapped_attributes)
        end
        proxy.public_send("on_#{type}_block").call(created_record, message)
      end
    end

    def default_do_create
      default_block = KafkaHandleEvent::DatabaseAdapter
        .default_create_block(KafkaHandleEvent.config.adapter)
      default_block.call(proxy.model_class, mapped_attributes)
    end

    def default_do_update
      default_block = KafkaHandleEvent::DatabaseAdapter
        .default_update_block(KafkaHandleEvent.config.adapter)
      id = mapped_attributes[proxy.primaries[0]]
      default_block.call(proxy.model_class, id, mapped_attributes)
    end

    def default_do_destroy
      default_block = KafkaHandleEvent::DatabaseAdapter
        .default_destroy_block(KafkaHandleEvent.config.adapter)
      id = mapped_attributes[proxy.primaries[0]]
      default_block.call(proxy.model_class, id, mapped_attributes)
    end

    def mapped_attributes
      @mapped_attributes ||= KafkaHandleEvent::AttributeMapper.new(proxy, message).attributes
    end
  end
end
