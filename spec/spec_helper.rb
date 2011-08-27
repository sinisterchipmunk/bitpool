$:.unshift File.expand_path("../lib", File.dirname(__FILE__))
require 'bitpool'
require 'fakeweb'
require 'database_cleaner'
require 'active_record'

Dir[File.expand_path('support/**/*.rb', File.dirname(__FILE__))].each { |f| require f }

FakeWeb.allow_net_connect = false

RSpec.configure do |c|
  c.before(:suite) do
    ActiveRecord::Base.establish_connection(:adapter => "sqlite3",
                                            :database => File.expand_path("fixtures/db.sqlite3", File.dirname(__FILE__)))

    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with :truncation
  end
  
  c.before(:each) do
    DatabaseCleaner.start
  end
  
  c.after(:each) do
    DatabaseCleaner.clean
  end
  
  c.include FixtureHelper
end
