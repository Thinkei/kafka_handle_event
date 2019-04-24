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
      attributes = mappers.inject(attributes) do |result, mapper|
        internal_column = mapper[0]
        external_column = mapper[1]
        default_value = mapper[2]
        result[internal_column] = message['data'][external_column] || default_value
        result
      end
      attributes
    end
  end
end
