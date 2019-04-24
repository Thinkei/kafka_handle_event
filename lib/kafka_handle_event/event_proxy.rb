class EventProxy
  attr_accessor :model_name, :topics, :attribute_mapper, :primaries

  def initialize(mobel_name)
    @model_name = mobel_name
    @topics = []
    @attribute_mapper = []
  end

  def topic(topic)
    @topics.push(topic)
    @topics = @topics.uniq
  end

  def primary_column(internal_id, external_id = nil)
    external_id ||= internal_id
    @primaries = [internal_id, external_id]
  end

  def map_column(internal, external, default_value = nil)
    @attribute_mapper << [internal, external, default_value]
  end
end
