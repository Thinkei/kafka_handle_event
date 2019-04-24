require 'spec_helper'
require 'kafka_handle_event/event_proxy'

describe EventProxy do
  let(:model_name) { :model_name }
  let(:subject) { described_class.new(model_name) }

  describe 'model_name' do
    it 'stores model name' do
      expect(subject.model_name).to equal(model_name)
    end
  end

  describe '#topic' do
    let(:topic_name) { 'topic_name' }

    it 'adds topic to topics list' do
      subject.topic topic_name
      expect(subject.topics).to include(topic_name)
    end
  end

  describe '#primary_column' do
    let(:internal_primary_column) { 'id' }
    let(:external_primary_column) { 'uuid' }

    it 'stores primary column as array' do
      subject.primary_column internal_primary_column, external_primary_column
      expect(subject.primaries).to eq([internal_primary_column, external_primary_column])
    end

    context 'does not pass external_primary_column' do
      it 'store external primary column as internal primary column' do
        subject.primary_column internal_primary_column
        expect(subject.primaries).to eq([internal_primary_column, internal_primary_column])
      end
    end
  end

  describe '#map_column' do
    let(:default_value) { 'default_value' }

    it 'adds column to attribute_mapper' do
      subject.map_column :internal, :external, default_value
      expect(subject.attribute_mapper).to include([:internal, :external, default_value])
    end
  end
end
