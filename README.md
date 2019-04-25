# kafka_handle_event
Helper to handle kafka events easier

## Install
```
gem 'kafka_handle_event'
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
  map_column :email, :email

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
