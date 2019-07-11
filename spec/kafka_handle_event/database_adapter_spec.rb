require 'spec_helper'
require 'kafka_handle_event/database_adapter'

describe KafkaHandleEvent::DatabaseAdapter do
  describe 'register' do
    let(:default_create_block) { ->() {} }

    it 'register new adapter' do
      described_class.register(:custom_adapter, :create, default_create_block)
      block = described_class.default_create_block(:custom_adapter)
      expect(block).to eq(default_create_block)
    end

    describe 'default_update_block' do
      let(:default_block) { ->() {} }
      it 'returns correct block' do
        described_class.register(:custom_adapter, :update, default_block)
        block = described_class.default_update_block(:custom_adapter)
        expect(block).to eq(default_block)
      end
    end

    describe 'default_destroy_block' do
      let(:default_block) { ->() {} }
      it 'returns correct block' do
        described_class.register(:custom_adapter, :destroy, default_block)
        block = described_class.default_destroy_block(:custom_adapter)
        expect(block).to eq(default_block)
      end
    end

    context 'invalid method name' do
      it 'raises erorr' do
        expect {
          described_class.register(:custom_adapter, :random_name, default_create_block)
        }.to raise_error("Method name is not in create, update, destroy")
      end
    end
  end
end
