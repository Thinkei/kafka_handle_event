require 'active_support/all'

module KafkaHandleEvent
  class EventProxy
    attr_accessor :model_name, :topics, :attribute_mapper, :primaries,
      :do_create_block, :do_update_block, :do_destroy_block,
      :on_create_block, :on_update_block, :on_destroy_block,
      :helpers_block


    def initialize(mobel_name)
      @model_name = mobel_name
      @topics = []
      @attribute_mapper = []
      @on_create_block = -> (a, b) {}
      @on_update_block = -> (a, b) {}
      @on_destroy_block = -> (a, b) {}
    end

    def topic(topic)
      @topics.push(topic)
      @topics = @topics.uniq
    end

    def primary_column(internal_id, external_id = nil)
      external_id ||= internal_id
      @primaries = [internal_id, external_id]
    end

    def map_column(*args, &block)
      internal = args[0]
      external = args[1]
      default_value = args[2]
      if block_given?
        @attribute_mapper << [internal, block, nil]
      else
        @attribute_mapper << [internal, external, default_value]
      end
    end

    def do_create(&block)
      @do_create_block = block
    end

    def do_update(&block)
      @do_update_block = block
    end

    def do_destroy(&block)
      @do_destroy_block = block
    end

    def on_create(&block)
      @on_create_block = block
    end

    def on_update(&block)
      @on_update_block = block
    end

    def on_destroy(&block)
      @on_destroy_block = block
    end

    def helpers(&block)
      self.instance_eval(&block)
    end

    def model_class
      Object.const_get(model_name.to_s.camelize) 
    rescue
      nil
    end
  end
end
