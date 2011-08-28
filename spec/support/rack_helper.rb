require 'rack'

module RackHelper
  def setup_fakeweb_response(json)
    if json['params'].empty?
      FakeWeb.register_uri(:post, 'http://user:pass@localhost:8332/', :response => fixture('getwork_without_params'))
    end
  end
  
  def post(path, params = {}, env = {})
    if path.is_a?(Symbol)
      params.reverse_merge!('method' => path.to_s)
      path = '/'
    end
    path = "/#{path}" if path !~ /^\//
    params.reverse_merge!({'jsonrpc' => '1.0', 'id' => 'curltest', 'params' => []})
    input = StringIO.new(params.to_json)
    
    setup_fakeweb_response(params)
    
    env = {
      "CONTENT_LENGTH"=>input.string.length,
      "CONTENT_TYPE"=>"text/plain;",
      "PATH_INFO"=>"/", 
      "REQUEST_METHOD"=>"POST", 
      "REQUEST_URI"=>"http://localhost:8332/", 
      "HTTP_AUTHORIZATION"=>"Basic YWNjb3VudF9rZXk6d29ya2VyX25hbWU=", 
      "HTTP_USER_AGENT"=>"curl/7.19.7 (universal-apple-darwin10.0) libcurl/7.19.7 OpenSSL/0.9.8r zlib/1.2.3", 
      "HTTP_HOST"=>"localhost:8332", 
      "HTTP_ACCEPT"=>"*/*", 
      "rack.version"=>[1, 1], 
      "rack.input"=>input,
      "rack.errors"=>$stderr, 
      "REQUEST_PATH"=>path
    }.merge(env)
    
    @response = app.call(env)
  end
  
  def response_json
    body = ""
    response.last.body.each { |s| body += s }
    JSON.load(body)
  end
  
  def app
    @app ||= Bitpool::Server.new_instance
  end
  
  def response
    @response
  end
end
