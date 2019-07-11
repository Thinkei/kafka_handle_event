module KafkaHandleEvent
  class Config
    def adapter
      @adapter || :active_record
    end

    def adapter=(adapter)
      @adapter = adapter
    end
  end
end
