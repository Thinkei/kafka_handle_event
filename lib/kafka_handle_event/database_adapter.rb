module KafkaHandleEvent
  class DatabaseAdapter
    @default_create_blocks = {}
    @default_update_blocks = {}
    @default_destroy_blocks = {}
    VALID_METHOD = [:create, :update, :destroy]

    class << self
      def register(adapter_name, method, default_block)
        unless VALID_METHOD.include?(method.to_sym)
          raise "Method name is not in #{VALID_METHOD.join(', ')}"
        end
        default_blocks = instance_variable_get("@default_#{method}_blocks")
        default_blocks[adapter_name] = default_block
      end

      def default_create_block(adapter_name)
        @default_create_blocks[adapter_name]
      end

      def default_update_block(adapter_name)
        @default_update_blocks[adapter_name]
      end

      def default_destroy_block(adapter_name)
        @default_destroy_blocks[adapter_name]
      end
    end
  end
end
