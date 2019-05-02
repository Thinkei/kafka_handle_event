require 'spec_helper'
require 'kafka_handle_event/attribute_mapper'
require 'kafka_handle_event/event_proxy'

describe KafkaHandleEvent::AttrbuteMapper do
  describe '#attributes' do
    let(:message) do
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
          'organisation_uuid' => 'organisation_uuid',
        }
      }
    end

    let(:proxy) { KafkaHandleEvent::EventProxy.new(:member) }
    let(:expected_attributes) do
      {
        id: 'member_uuid',
        in_first_name: 'Huy Vo',
        in_last_name: 'bede',
        somefield: 'default_somefield',
        empty_field: 'default_empty_field'
      }
    end

    context 'forget to setup primary_column' do
      before do
        proxy.map_column :in_first_name, :first_name
        proxy.map_column :in_last_name, :last_name
        proxy.map_column :somefield, :external_somefield, 'default_somefield'
        proxy.map_column :empty_field, :empty_field, 'default_empty_field'
      end

      it 'returns attributes after mapped' do
        expect {
          described_class.new(proxy, message).attributes
        }.to raise_error('Need to setup primary_column for event member')
      end
    end

    context 'setup primary_column' do
      before do
        proxy.primary_column :id, :uuid
        proxy.map_column :in_first_name, :first_name
        proxy.map_column :in_last_name, :last_name
        proxy.map_column :somefield, :external_somefield, 'default_somefield'
        proxy.map_column :empty_field, :empty_field, 'default_empty_field'
      end

      it 'returns attributes after mapped' do
        expect(described_class.new(proxy, message).attributes).to eq(expected_attributes)
      end
    end

    context 'map column passing a block' do
      let(:expected_attributes) do
        {
          id: 'member_uuid',
          in_first_name: '01/01/2016',
          in_last_name: 'bede',
          somefield: 'default_somefield',
          empty_field: 'default_empty_field'
        }
      end

      before do
        proxy.primary_column :id, :uuid
        proxy.map_column :in_first_name do |raw_attrs|
          raw_attrs[:data][:start_date]
        end
        proxy.map_column :in_last_name, :last_name
        proxy.map_column :somefield, :external_somefield, 'default_somefield'
        proxy.map_column :empty_field, :empty_field, 'default_empty_field'
      end

      it 'returns attributes after mapped' do
        expect(described_class.new(proxy, message).attributes).to eq(expected_attributes)
      end
    end

    context 'destroy mesage' do
      let(:message) do
        {
          'topic_type' => 'topic_name',
          'event' => 'create',
          'uuid' => 'member_uuid',
        }
      end

      let(:expected_attributes) do
        {
          id: 'member_uuid',
        }
      end

      before do
        proxy.primary_column :id, :uuid
      end

      it 'returns attributes after mapped' do
        expect(described_class.new(proxy, message).attributes).to eq(expected_attributes)
      end
    end
  end
end
