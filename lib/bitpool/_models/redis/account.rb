class Bitpool::Models::Redis::Account < Bitpool::Models::Redis
  attr_reader :worker, :key
  attr_writer :key
  
  def worker=(worker_name)
    @worker = Bitpool::Models::Redis::Worker.new(:name => worker_name, :account => key)
  end
  
  def initialize(attributes = {})
    attributes[:key] = File.join("accounts", attributes[:key]) if attributes[:key]
    super
    connection.sadd key, worker unless connection.sismember(key, worker)
  end
  
  class << self
    def authenticate(login, password)
      new(:key => login, :worker => password)
    end
  end
end
