class Bitpool::Configuration
  attr_accessor :bitcoind_username
  attr_accessor :bitcoind_password
  attr_accessor :bitcoind_host
  attr_accessor :bitcoind_port
  
  def initialize(defaults = {})
    @bitcoind_username = 'user'
    @bitcoind_password = 'pass'
    @bitcoind_host     = 'localhost'
    @bitcoind_port     = 8332
    
    defaults.each do |key, value|
      send("#{key}=", value)
    end
  end
  
  def redis_port=(port)
    Redis.port = port
  end
  
  def redis_port
    Redis.port
  end
  
  def redis_host=(host)
    Redis.host = host
  end
  
  def redis_host
    Redis.host
  end
  
  private
  def find_class(m)
    case m
      when String then eval(m)
      else m
    end
  end
end
