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
### Basic example

```ruby
require "databasedotcom-streaming"
EM.run{
  client = Databasedotcom::Client.new
  client.authenticate(:token => my-access-token, :instance_url => my-instance-url, :refresh_token => my-refresh-token) 
  client.subscribe_to_push_topic('AllLeads'){ |message| puts message.inspect }
}
```

### Rails

```ruby
use Databasedotcom::OAuth2::WebServerFlow, 
  :endpoints => {"login.salesforce.com" => {:key => "replace me", :secret => "replace me"},
                 "test.salesforce.com"  => {:key => "replace me", :secret => "replace me"}}
```

### Sinatra
```ruby
use Databasedotcom::OAuth2::WebServerFlow, 
  :display   => "touch"        , #default is "page"
  :immediate => true           , #default is false
  :prompt    => "login consent", #default is nil
  :scope     => "full"           #default is "id api refresh_token"
```
  
## Resources
* [OAuth 2.0 Web Server Authentication Flow](http://na12.salesforce.com/help/doc/en/remoteaccess_oauth_web_server_flow.htm)
* [Article: Digging Deeper into OAuth 2.0 on Force.com](http://wiki.developerforce.com/index.php/Digging_Deeper_into_OAuth_2.0_on_Force.com)