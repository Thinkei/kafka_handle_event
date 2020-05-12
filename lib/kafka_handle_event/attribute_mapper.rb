module KafkaHandleEvent
  class AttrbuteMapper
    attr_accessor :proxy, :message
    def initialize(proxy, message)
      @proxy = proxy
      @message = message.with_indifferent_access
    end

    def attributes
      mappers = proxy.attribute_mapper
      if proxy.primaries.nil?
        raise "Need to setup primary_column for event #{proxy.model_name}"
      end

      attributes = {}
      internal_primary_id = proxy.primaries[0]
      external_primary_id = proxy.primaries[1]
      attributes[internal_primary_id] = message[external_primary_id]
      attributes = mappers.each_with_object(attributes) do |mapper, result|
        internal_column = mapper[0]
        result[internal_column] = if mapper[1].is_a? Proc
                                    get_block_map_value(mapper, message)
                                  else
                                    get_attrbute_map_value(mapper, message)
                                  end
      end
      attributes
    end

    private

    def get_attrbute_map_value(mapper, message)
      external_column = mapper[1]
      default_value = mapper[2]
      if message[:data] && !message[:data][external_column].nil?
        message[:data][external_column]
      else
        default_value
      end
    end

    def get_block_map_value(mapper, message)
      block = mapper[1]
      block.call(message)
    end
  end
end
