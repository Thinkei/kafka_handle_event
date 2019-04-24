require 'spec_helper'
require 'kafka_handle_event/event_proxy'

describe EventProxy do
  describe 'model_name' do
    let(:model_name) { :model_name }
    let(:subject) { described_class.new(model_name) }
    
    it 'stores model name' do
      expect(subject.model_name).to equal(model_name)
    end
  end
end
