class EventProxy
  attr_accessor :model_name, :topics, :attribute_mapper

  def initialize(mobel_name)
    @model_name = mobel_name
    @topics = []
    attribute_mapper = []
  end

  def topic(topic)
    @topics.push(topic)
    @topics = @topics.uniq
  end
end
