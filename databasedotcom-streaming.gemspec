Gem::Specification.new do |s|
  s.name          = 'databasedotcom-streaming'
  s.version       = '0.0.1'
  s.date          = '2012-08-20'
  s.summary       = "A ruby gem to connect to the Salesforce.com Streaming API"
  s.description   = "A ruby gem to connect to the Salesforce.com Streaming API"
  s.authors       = ["Doug Friedman"]
  s.email         = 'dfriedm3@gmail.com'
  s.files         = ["lib/databasedotcom-streaming.rb"]
  s.homepage      = 'http://rubygems.org/gems/databasedotcom-streaming'

  s.add_runtime_dependency "databasedotcom"
  s.add_runtime_dependency "faye"
  s.add_runtime_dependency "eventmachine"
end