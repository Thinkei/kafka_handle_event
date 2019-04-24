class EventProxy
  attr_accessor :model_name, :topics, :attribute_mapper, :primaries,
    :do_create_block, :do_update_block, :do_destroy_block,
    :on_create_block, :on_update_block, :on_destroy_block


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

  def do_create(block)
    @do_create_block = block
  end

  def do_update(block)
    @do_update_block = block
  end

  def do_destroy(block)
    @do_destroy_block = block
  end

  def on_create(block)
    @on_create_block = block
  end

  def on_update(block)
    @on_update_block = block
  end

  def on_destroy(block)
    @on_destroy_block = block
  end

  private

  def default_do_create
  end
end
