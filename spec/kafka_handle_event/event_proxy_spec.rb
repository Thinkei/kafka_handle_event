require 'spec_helper'
require 'kafka_handle_event/event_proxy'

describe KafkaHandleEvent::EventProxy do
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
    let(:map_block) { -> (raw_attrs) {} }

    it 'adds column to attribute_mapper' do
      subject.map_column :internal, :external, default_value
      expect(subject.attribute_mapper).to include([:internal, :external, default_value])
    end

    it 'allows to add mapper as a block' do
      subject.map_column :internal, map_block, default_value
      expect(subject.attribute_mapper).to include([:internal, map_block, default_value])
    end
  end

  describe 'do_create' do
    let(:block) { -> (data) { p data } }

    it 'stores do create block' do
      subject.do_create &block
      expect(subject.do_create_block).to eq(block)
    end
  end

  describe 'do_create' do
    let(:block) { -> (data) { p data } }

    it 'stores do create block' do
      subject.do_create &block
      expect(subject.do_create_block).to eq(block)
    end
  end

  describe 'do_update' do
    let(:block) { -> (data) { p data } }

    it 'stores do update block' do
      subject.do_update &block
      expect(subject.do_update_block).to eq(block)
    end
  end

  describe 'do_destroy' do
    let(:block) { -> (data) { p data } }

    it 'stores do destroy block' do
      subject.do_destroy &block
      expect(subject.do_destroy_block).to eq(block)
    end
  end

  describe 'on_create' do
    let(:block) { -> (data) { p data } }

    it 'stores do create block' do
      subject.on_create &block
      expect(subject.on_create_block).to eq(block)
    end
  end

  describe 'on_update' do
    let(:block) { -> (data) { p data } }

    it 'stores do update block' do
      subject.on_update &block
      expect(subject.on_update_block).to eq(block)
    end
  end

  describe 'on_destroy' do
    let(:block) { -> (data) { p data } }

    it 'stores do destroy block' do
      subject.on_destroy &block
      expect(subject.on_destroy_block).to eq(block)
    end
  end

  describe 'helpers' do
    let(:block) do
      Proc.new {
        def test_method
          p 'aaa'
        end
      }
    end

    it 'stores helpers block' do
      subject.helpers &block
      expect { subject.test_method }.not_to raise_error
    end
  end

  describe 'model_class' do
    context 'model is exist' do
      let(:model_name) { :model_a }

      it 'returns model class' do
        expect(subject.model_class).to eq(ModelA)
      end
    end

    context 'model is not exist' do
      it 'returns nil' do
        expect(subject.model_class).to be_nil
      end
    end
  end
end

class ModelA
end

