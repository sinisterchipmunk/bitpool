module RedisHelper
  def connection
    @connection ||= Redis.connection
  end
  
  alias redis connection
end
