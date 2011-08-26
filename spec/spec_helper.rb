$:.unshift File.expand_path("../lib", File.dirname(__FILE__))
require 'bitpool'
require 'fakeweb'

Dir[File.expand_path('support/**/*.rb', File.dirname(__FILE__))].each { |f| require f }

FakeWeb.allow_net_connect = false

RSpec.configure do |c|
  c.before(:each) do
    Redis.connection.select "test-bitpool-gem"
    Redis.connection.flushdb
  end
  
  c.include FixtureHelper
end
