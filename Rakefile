require "bundler/gem_tasks"
require 'rspec/core/rake_task'

desc 'Default: run specs.'
task :default => :spec

desc "Run specs"
RSpec::Core::RakeTask.new

desc "start bitpool on a webrick server"
task :server do
  require 'bitpool'
  require 'rack'
  Rack::Server.new(:app => proc { |env| Bitpool::Server.new.call(env) }, :Port => ENV['PORT'] || 3002).start
end
