What is databasedotcom-streaming?
------------------------------

This gem is an extension of the [databasedotcom](https://rubygems.org/gems/databasedotcom) gem that makes it simple and convenient to consume the [salesforce.com](http://salesforce.com/) Streaming API in Ruby.  It relies on the excellent [Faye](faye.jcoglan.com) to subscribe to Salesforce's streaming servers and execute evented callbacks without introducing blocks in your code.

Notes
-------
* The only prerequisites for using the gem are to have it present in your system and to require it in your project.  If you are already using the databasedotcom gem, this gem will integrate seamlessly with what you are already using.
* This gem currently relies on [eventmachine](https://rubygems.org/gems/eventmachine) to run, so you're streaming code must be run from within an EventMachine block. If you are using an event based server like Thin, then you are all set.
* If you are using OAuth, be sure to include a refresh token when authenticating ... otherwise the stream will stop working when the access token expires.

Usage
-------

Use the 'subscribe_to_push_topic' method to listen to a streaming channel and pass a topic name and callback as arguments.  Whenever the stream has new information to publish, it will call your callback and pass it an argument representing the new message in the form of a hash.

### Setup

```ruby
require "databasedotcom-streaming"

client = Databasedotcom::Client.new
client.authenticate(:token => my-access-token, :instance_url => my-instance-url, :refresh_token => my-refresh-token)  

```

### Subscribe

```ruby
EM.run{
  client.subscribe_to_push_topic('MyStreamingTopic'){ |message| puts message.inspect }
}
```

or 

```ruby
EM.run{
  client.subscribe_to_push_topic('MyStreamingTopic') do |message|
    # my block of code
    # goes here
    # and here
  end
}
```

### See your push topics

```ruby

client.materialize 'PushTopic'
all_push_topics = PushTopic.all
puts all_push_topics.to_yaml

```

### Create a new topic

```ruby
topic_attrs = {
  :query => 'SELECT Id, Name FROM Lead WHERE Source = \'Web\'' # All inbound leads that come from the web 
  :name  => 'WebLeads'
}

client.create('PushTopic', topic_attrs)

```


Possible Uses
-------

* A message queue backed in Databasedotcom
* A service that pre caches data from Force.com into a local db or datastore
* Push Notifications (Desktop, Mobile)
  
## Resources
* [OAuth 2.0 Web Server Authentication Flow](http://na12.salesforce.com/help/doc/en/remoteaccess_oauth_web_server_flow.htm)
* [Article: Digging Deeper into OAuth 2.0 on Force.com](http://wiki.developerforce.com/index.php/Digging_Deeper_into_OAuth_2.0_on_Force.com)