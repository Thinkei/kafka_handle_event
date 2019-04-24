require 'spec_helper'
require 'kafka_handle_event'

describe KafkaHandleEvent do
  describe '#configure' do
    it 'do somethings' do
      expect(1).to eq(1)
    end
  end

  describe '#register' do
    describe 'topic method' do
      it 'adds topic to topics list' do
        described_class.register :member do
          topic 'topic_name'
        end

        expect(described_class.topics).to eq(['topic_name'])
      end
    end
  end
end
