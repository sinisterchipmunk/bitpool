require 'rack'

class Bitpool::Server
  attr_accessor :account
  
  def call(env)
    request = Rack::Request.new(env)
    response = Rack::Response.new
    case request.path
      when '/' then process_getwork(request, response)
      else raise "Invalid path #{request.path}"
    end
    response.finish
  end
  
  def process_getwork(request, response)
    json = (JSON.load(request.body.read) || {})
    if json && json['params'].empty?
      result = account.request_work(json)
    else
      result = account.complete_work(json)
    end
    response['Content-Type'] = 'text/json'
    response.write(result.to_json)
  end
  
  class << self
    def new_instance
      app = new
      auth_layer = Rack::Auth::Basic.new(app) do |username, password|
        begin
          app.account = Bitpool::Account.authenticate(username, password)
          true
        rescue
          puts $!.message, $!.backtrace
          false
        end
      end
      auth_layer.realm = "Bitpool"
      auth_layer
    end
  end
end
