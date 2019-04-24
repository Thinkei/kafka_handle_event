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

    def handle_create
      created_record = nil
      if proxy.model_class && proxy.do_create_block.nil?
        created_record = default_do_create
      else
        raise "Need to setup do_create on model #{proxy.model_name}" unless proxy.do_create_block
        created_record = proxy.do_create_block.call(mapped_attributes)
      end
      proxy.on_create_block.call(created_record, message)
    end

    def default_do_create
      proxy.model_class.create(mapped_attributes)
    end

    def mapped_attributes
      @mapped_attributes ||= KafkaHandleEvent::AttrbuteMapper.new(proxy, message).attributes
    end
  end
end
