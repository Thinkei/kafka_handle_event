require 'spec_helper'
require 'kafka_handle_event'
require 'kafka_handle_event/event_handler'

describe KafkaHandleEvent do
  describe '#configure' do
    it 'do somethings' do
      expect(1).to eq(1)
    end
  end

  describe '#register' do
    it 'can call register to register event' do
      described_class.register :member do
        topic 'topic_name'
        primary_column :id
        map_column :name, :name, 'Default name'
      end
    end

    describe '#topics method' do
      it 'gets topics list' do
        described_class.register :member do
          topic 'topic_name'
          topic 'topic_name_2'
        end

        described_class.register :member_2 do
          topic 'topic_name_3'
        end

        expect(described_class.topics).to eq(['topic_name', 'topic_name_2', 'topic_name_3'])
      end
    end

  end

    describe '#handle_event' do
      let(:topic) { 'has not register topic' }
      let(:create_message) do
        {
          'topic_type' => topic,
          'event' => 'create',
          'uuid' => 'member_uuid',
          'data' => {
            'start_date' => '01/01/2016',
            'date_of_birth' => '02/02/1990',
            'active' => true,
            'first_name' => 'Hoang',
            'last_name' => 'Tran',
            'avatar_url' => '/avartar.png',
            'email' => 'email@email.com',
            'organisation_uuid' => 'organisation_uuid',
          }
        }
      end

      context 'event has not been registered to handle' do
        it 'does nothing' do
          expect_any_instance_of(KafkaHandleEvent::EventHandler).not_to receive(:handle_event)
          described_class.handle_event(create_message)
        end
      end

      context 'event has been registered to handle' do
        let(:topic) { 'aaa_topic' }
        before do
          described_class.register :member do
            topic 'aaa_topic'
          end
        end

        it 'calls handle_event of event handler' do
          expect_any_instance_of(KafkaHandleEvent::EventHandler).to receive(:handle_event)
          described_class.handle_event(create_message)
        end
      end
    end
end
