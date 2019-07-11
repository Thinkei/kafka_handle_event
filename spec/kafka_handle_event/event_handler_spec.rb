require 'spec_helper'
require 'kafka_handle_event/event_proxy'
require 'kafka_handle_event/event_handler'

describe KafkaHandleEvent::EventHandler do
  describe '#handle_event' do
    context 'event type is create' do
      let(:create_message) do
        {
          'topic_type' => 'topic_name',
          'event' => 'create',
          'uuid' => 'member_uuid',
          'data' => {
            'start_date' => '01/01/2016',
            'date_of_birth' => '02/02/1990',
            'active' => true,
            'first_name' => 'Huy Vo',
            'last_name' => 'bede',
            'avatar_url' => '/avartar.png',
            'email' => 'email@email.com',
            'organisation_uuid' => 'organisation_uuid'
          }
        }
      end
      context 'model is exist' do
        let(:proxy) { KafkaHandleEvent::EventProxy.new(:member) }

        context 'do not provide custom do_create block' do
          it 'calls default do_create block' do
            expect_any_instance_of(described_class).to receive(:default_do_create)
            described_class.new(proxy, create_message).handle_event
          end
        end

        context 'provide custom do_create block' do
          let(:custom_do_create) { ->(attrs) { p attrs } }
          before do
            proxy.do_create &custom_do_create
            proxy.primary_column :id, :uuid
          end
          it 'calls custom do_create block' do
            expect_any_instance_of(described_class).not_to receive(:default_do_create)
            expect(custom_do_create).to receive(:call)
            described_class.new(proxy, create_message).handle_event
          end
        end
      end

      context 'model is not exist' do
        context 'provide custom do_create block' do
          let(:proxy) { KafkaHandleEvent::EventProxy.new(:randome) }
          let(:custom_do_create) { ->(attrs) { p attrs } }
          before do
            proxy.do_create &custom_do_create
            proxy.primary_column :id, :uuid
          end

          it 'calls custom do_create block' do
            expect_any_instance_of(described_class).not_to receive(:default_do_create)
            expect(custom_do_create).to receive(:call)
            described_class.new(proxy, create_message).handle_event
          end
        end

        context 'does not provide do_create block' do
          let(:proxy) { KafkaHandleEvent::EventProxy.new(:randome) }
          let(:custom_do_create) { ->(attrs) { p attrs } }
          before do
            proxy.primary_column :id, :uuid
          end

          it 'calls custom do_create block' do
            expect_any_instance_of(described_class).not_to receive(:default_do_create)
            expect do
              described_class.new(proxy, create_message).handle_event
            end.to raise_error('Need to setup do_create on model randome')
          end
        end
      end

      describe 'on_create' do
        let(:proxy) { KafkaHandleEvent::EventProxy.new(:member) }
        let(:on_create_block) { ->(created_record, message) {} }
        before do
          proxy.primary_column :id, :uuid
          proxy.on_create &on_create_block
        end
        let(:created_model) { double }

        it 'calls on_create block after create' do
          expect_any_instance_of(described_class).to receive(:default_do_create).and_return(created_model)
          expect(on_create_block).to receive(:call).with(created_model, create_message)
          described_class.new(proxy, create_message).handle_event
        end
      end
    end
  end

  describe 'default on create block' do
    let(:proxy) do
      px = KafkaHandleEvent::EventProxy.new(:member)
      px.primary_column(:id, :uuid)
      px
    end
    let(:create_message) do
      {
        'topic_type' => 'topic_name',
        'event' => 'create',
        'uuid' => 'member_uuid',
        'data' => {
          'start_date' => '01/01/2016',
          'date_of_birth' => '02/02/1990',
          'active' => true,
          'first_name' => 'Huy Vo',
          'last_name' => 'bede',
          'avatar_url' => '/avartar.png',
          'email' => 'email@email.com',
          'organisation_uuid' => 'organisation_uuid'
        }
      }
    end

    context 'adapter is sequel' do
      before do
        KafkaHandleEvent.configure do |config|
          config.adapter = :sequel
        end
      end

      let(:default_block) { KafkaHandleEvent::DatabaseAdapter.default_create_block(:sequel) }
      it 'calls default sequel do create block' do
        expect(default_block).to receive(:call)
        described_class.new(proxy, create_message).handle_event
      end
    end

    context 'adapter is activerecord' do
      before do
        KafkaHandleEvent.configure do |config|
          config.adapter = :active_record
        end
      end
      let(:default_block) { KafkaHandleEvent::DatabaseAdapter.default_create_block(:active_record) }

      it 'calls default activerecord do create block' do
        expect(default_block).to receive(:call)
        described_class.new(proxy, create_message).handle_event
      end
    end
  end

  describe 'default on update block' do
    let(:proxy) do
      px = KafkaHandleEvent::EventProxy.new(:member)
      px.primary_column(:id, :uuid)
      px
    end
    let(:update_message) do
      {
        'topic_type' => 'topic_name',
        'event' => 'update',
        'uuid' => 'member_uuid',
        'data' => {
          'start_date' => '01/01/2016',
          'date_of_birth' => '02/02/1990',
          'active' => true,
          'first_name' => 'Huy Vo',
          'last_name' => 'bede',
          'avatar_url' => '/avartar.png',
          'email' => 'email@email.com',
          'organisation_uuid' => 'organisation_uuid'
        }
      }
    end

    context 'adapter is sequel' do
      before do
        KafkaHandleEvent.configure do |config|
          config.adapter = :sequel
        end
      end
      let(:default_block) { KafkaHandleEvent::DatabaseAdapter.default_update_block(:sequel) }

      it 'calls default sequel do update block' do
        expect(default_block).to receive(:call)
        described_class.new(proxy, update_message).handle_event
      end
    end

    context 'adapter is activerecord' do
      before do
        KafkaHandleEvent.configure do |config|
          config.adapter = :active_record
        end
      end
      let(:default_block) { KafkaHandleEvent::DatabaseAdapter.default_update_block(:active_record) }

      it 'calls default activerecord do update block' do
        expect(default_block).to receive(:call)
        described_class.new(proxy, update_message).handle_event
      end
    end
  end

  describe 'default on destroy block' do
    let(:proxy) do
      px = KafkaHandleEvent::EventProxy.new(:member)
      px.primary_column(:id, :uuid)
      px
    end
    let(:destroy_message) do
      {
        'topic_type' => 'topic_name',
        'event' => 'destroy',
        'uuid' => 'member_uuid',
        'data' => {
          'start_date' => '01/01/2016',
          'date_of_birth' => '02/02/1990',
          'active' => true,
          'first_name' => 'Huy Vo',
          'last_name' => 'bede',
          'avatar_url' => '/avartar.png',
          'email' => 'email@email.com',
          'organisation_uuid' => 'organisation_uuid'
        }
      }
    end

    context 'adapter is sequel' do
      before do
        KafkaHandleEvent.configure do |config|
          config.adapter = :sequel
        end
      end
      let(:default_block) { KafkaHandleEvent::DatabaseAdapter.default_destroy_block(:sequel) }

      it 'calls default sequel do destroy block' do
        expect(default_block).to receive(:call)
        described_class.new(proxy, destroy_message).handle_event
      end
    end

    context 'adapter is activerecord' do
      before do
        KafkaHandleEvent.configure do |config|
          config.adapter = :active_record
        end
      end
      let(:default_block) { KafkaHandleEvent::DatabaseAdapter.default_destroy_block(:active_record) }

      it 'calls default activerecord do destroy block' do
        expect(default_block).to receive(:call)
        described_class.new(proxy, destroy_message).handle_event
      end
    end
  end
end

class Member
end
