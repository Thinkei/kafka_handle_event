# kafka_handle_event
Helper to handle kafka events easier

## Install
```
gem 'kafka_handle_event'
```

## Config
Add `config/initializers/kafka_handle_event.rb`
```ruby
KafkaHandleEvent.configure do |config|
  # default adatper is :active_record
  config.adapter = :sequel # in case you use sequel instead of active record
end
```

Customize default behavior
```ruby
# config/initializers/kafka_handle_event.rb
KafkaHandleEvent::DatabaseAdapter.register :active_record, :create, ->(model_class, attributes) do
  # do custom logic
end

KafkaHandleEvent::DatabaseAdapter.register :active_record, :update, ->(model_class, id, attributes) do
  # do custom logic
end

KafkaHandleEvent::DatabaseAdapter.register :active_record, :destroy, ->(model_class, id, attributes) do
  # do custom logic
end

```

## Kafka message format
This lib has its opinion about the message shape it support. The message should have this shape:
```json
  {
    'topic_type' => 'topic_name',
    'event' => 'create',
    'uuid' => 'uuid',
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
```

`topic_type`, `event` is required.

## Add kafka event handler

Old:
```ruby
      TOPIC_NAMES.each do |topic_name|
        consumer.subscribe(topic_name)
      end

      consumer.each_message(max_wait_time: 2) do |message|
        handle_kafka_message(message)
      end
```

New:
```ruby
      KafkaHandleEvent.topics.each do |topic_name|
        consumer.subscribe(topic_name)
      end

      consumer.each_message(max_wait_time: 2) do |message|
        new_message = JSON.parse(message.value).merge(topic_type: message.topic)
        KafkaHandleEvent.handle_event(new_message)
      end
```

## Add new model to subscribe

`kafka_member.rb`
```ruby
KafkaHandleEvent.register :member do
  topic 'EmploymentHero.Member'

  primary_column :id, :uuid 
  map_column :organisation_id, :organisation_uuid
  map_column :avatar_url, :avatar_url
  map_column :first_name, :first_name
  map_column :last_name, :last_name
  map_column :email do |raw_message|
    raw_message[:data][:user_email]
  end

  on_create do |record, raw_message|
    #callback after create
  end

  on_update do |record, raw_message|
    #callback after update
  end

  on_destroy do |record, raw_message|
    #callback after destroy
  end
end

```

To override default behaviour of sync event

```ruby
KafkaHandleEvent.register :member do
  topic 'EmploymentHero.Member'

  primary_column :id, :uuid 
  map_column :organisation_id, :organisation_uuid
  map_column :avatar_url, :avatar_url
  map_column :first_name, :first_name
  map_column :last_name, :last_name
  map_column :email, :email

  do_create do |mapped_attributes|
  end

  do_update do |mapped_attributes|
  end

  do_destroy do |mapped_attributes|
  end

  on_create do |record, raw_message|
    #callback after create
  end

  on_update do |record, raw_message|
    #callback after update
  end

  on_destroy do |record, raw_message|
    #callback after destroy
  end
end
```

Add helpers


```ruby
KafkaHandleEvent.register :member do
  topic 'EmploymentHero.Member'

  primary_column :id, :uuid 
  map_column :organisation_id, :organisation_uuid

  do_create do |mapped_attributes|
    do_something
  end

  do_update do |mapped_attributes|
    do_something
  end

  helpers do
    def do_something
      # ...do something
    end
  end
end
```


## Testing
### rspec

Require your handlers/kafka consumer to `spec_helper`

```
# messasge_bus/kafka_subscriber.rb

require './message_bus/kafka_organisation.rb'
require './message_bus/kafka_member.rb'

```

Add this require
```
# spec/spec_helper.rb

# https://stackoverflow.com/questions/11376718/require-lib-in-rspec-with-ruby-1-9-2-brings-no-such-file-to-load
$:<< File.join(File.dirname(__FILE__), '..')

require 'message_bus/kafka_subscriber.rb'

```

Write test for your handler
```
# spec/message_bus/kafka_member_spec.rb

require 'rails_helper'
require 'spec_helper'

describe 'kafka_message_handler' do
  context 'success message' do
    let(:topic) { 'EmploymentHero.Member' }
    let(:success_message) do
      {
        'topic_type' => topic,
        'event' => 'create',
        'uuid' => 'member_id',
        'data' => {
          'name': 'Huy be de',
          'title': 'Mobile Project Lead LOL'
        }
      }
    end

    it 'update create member' do
      expect {
	KafkaHandleEvent.handle_event(success_message)
      }.to change(Member, :count).by(1)
    end
  end

  ...
end


```
