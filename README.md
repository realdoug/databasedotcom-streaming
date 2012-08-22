What is databasedotcom-streaming?
------------------------------
**This gem is an extension of the [databasedotcom](https://rubygems.org/gems/databasedotcom) gem that makes it simple and convenient to consume the [salesforce.com](http://salesforce.com/) Streaming API in Ruby

Usage
-------

### Minimal 

```ruby
require "databasedotcom-streaming"
client = Databasedotcom::Client.new
client.authenticate(:token => my-access-token, :instance_url => my-instance-url, :refresh_token => my-refresh-token) 

```

Insert above code wherever your [Rack](http://rack.github.com/) Stack is defined.  See [Required Configuration Parameters](#required-configuration-parameters) for more information on parameters.

### Multiple Endpoints 

```ruby
use Databasedotcom::OAuth2::WebServerFlow, 
  :endpoints => {"login.salesforce.com" => {:key => "replace me", :secret => "replace me"},
                 "test.salesforce.com"  => {:key => "replace me", :secret => "replace me"}}
```

### Authentication
```ruby
use Databasedotcom::OAuth2::WebServerFlow, 
  :display   => "touch"        , #default is "page"
  :immediate => true           , #default is false
  :prompt    => "login consent", #default is nil
  :scope     => "full"           #default is "id api refresh_token"
```

### Miscellaneous
```ruby
use Databasedotcom::OAuth2::WebServerFlow, 
  :api_version => "24.0"      , #default is 25.0
  :debugging   => "true"      , #default is false
  :path_prefix => "/auth/sfdc"  #default is /auth/salesforce
```

Required Configuration Parameters
-----------------------------------

* **`:endpoints`**

    Hash of remote access applications; at least one is required.  Values must be generated via [salesforce.com](http://salesforce.com/) at Setup > App Setup > Develop > Remote Access.  Only one remote access application is needed for production, sandbox, or pre-release; separate entries are not necessary for My Domain.

    Example:
    ```ruby
    :endpoints => {"login.salesforce.com" => {:key => "replace me", :secret => "replace me"}
                   "test.salesforce.com"  => {:key => "replace me", :secret => "replace me"}}
     ```

     *Default:* nil

* **`:token_encryption_key`**

    Encrypts OAuth 2.0 token prior to persistence in session store.  Any Rack session store can be used:  Rack:Session:Cookie, Rack:Session:Pool, etc.  A sufficiently strong key **must** be generated.  It's recommended you use the following command to generate a random key value.  

    ```
    ruby -ropenssl -rbase64 -e "puts Base64.strict_encode64(OpenSSL::Random.random_bytes(16).to_str)"
    ```

    It's also recommended you store the key value as an environment variable as opposed to a string literal in your code.  To both create the key value and store as an environment variable, use this command:
    
    ```
    export TOKEN=`ruby -ropenssl -rbase64 -e "puts Base64.strict_encode64(OpenSSL::Random.random_bytes(16).to_str)"`
    ```
    
    Then, in your code, decrypt prior to use:

    ```ruby
    require "base64"
    Base64.strict_decode64(ENV['TOKEN'])
    ```

    *Default:* nil
    
Optional Configuration Parameters
-----------------------------------

* **`:display`, `:immediate`, `:prompt`, `:scope`**

    Values passed directly to [salesforce.com](http://salesforce.com/) which control authentication behavior.  See [OAuth 2.0 Web Server Authentication Flow](http://na12.salesforce.com/help/doc/en/remoteaccess_oauth_web_server_flow.htm#heading_2_1) for detailed explanation as well as valid and default values.

    *Default:* see [OAuth 2.0 Web Server Authentication Flow](http://na12.salesforce.com/help/doc/en/remoteaccess_oauth_web_server_flow.htm#heading_2_1)
    
* **`:display_override`,`:immediate_override`, `:prompt_override`,`:scope_override`**

    Allow correspondingly named parameter to be overridden at runtime via http parameter of same name.  For example, if your app is capable of detecting the client device type, set **`:display_override`** to true and pass a display http parameter to `/auth/salesforce`.  

    *Default:* false

* **`:api_version`**

    For explanation of api versions, see [What's New in Version XX.X](http://www.salesforce.com/us/developer/docs/api/Content/whats_new.htm)

    *Default:* 25.0

* **`:debugging`**

    Will enable debug output for both this gem and [databasedotcom](https://rubygems.org/gems/databasedotcom).

    *Default:* false

* **`:on_failure`**

    A lambda block to be executed upon authentication failure.

    *Default:* redirect to `/auth/salesforce/failure` with error message passed via message http parameter.

* **`:path_prefix`**

    The path that signals databasedotcom-oauth2 to initiate authentication with [salesforce.com](http://salesforce.com/).

    *Default:* /auth/salesforce
  
## Resources
* [OAuth 2.0 Web Server Authentication Flow](http://na12.salesforce.com/help/doc/en/remoteaccess_oauth_web_server_flow.htm)
* [Article: Digging Deeper into OAuth 2.0 on Force.com](http://wiki.developerforce.com/index.php/Digging_Deeper_into_OAuth_2.0_on_Force.com)