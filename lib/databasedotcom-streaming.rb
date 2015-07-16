require 'databasedotcom'
require 'faye'
require 'eventmachine'

module Databasedotcom
  class Client
    def subscribe_to_push_topic(push_topic_name, &callback)
      raise 'You must run this method inside of an EventMachine loop.' unless EM.reactor_running?
      version = self.version
      faye = Faye::Client.new(self.instance_url+"/cometd/#{version}")
      puts 'connecting to '+self.instance_url+"/cometd/#{version}"
      faye.bind 'transport:down' do
        puts 'trying to refresh token'
        list_sobjects # to refresh the access token
        faye.set_header 'Authorization', "OAuth #{self.oauth_token}"
      end
      if push_topic_name.kind_of?(Array)
        push_topic_name.map!{|push_topic| '/topic/'+ push_topic}
      else
        push_topic_name = '/topic/' + push_topic_name
      end
      faye.subscribe(push_topic_name){ |message| callback.call(message) }
    end
  end
end
