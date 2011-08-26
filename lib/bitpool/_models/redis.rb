require 'redis'
require 'json'

class Bitpool::Models::Redis
  @@connection = nil
  extend ActiveModel::Naming
  include ActiveModel::Validations
  
  autoload :Errors, "bitpool/models/redis/errors"
  autoload :Credit, "bitpool/models/redis/credit"
  autoload :Share,  "bitpool/models/redis/share"
  autoload :Account,"bitpool/models/redis/account"
  autoload :Worker, "bitpool/models/redis/worker"
  
  def to_param
    # nil when !persisted?
    nil
  end
  
  def to_key
    # nil when !persisted?; [primary-keys] otherwise
    nil
  end
  
  def persisted?
    # !new_record?
    false
  end
  
  def connection
    self.class.connection
  end
  
  def serialize
    attributes.to_json
  end
  
  def initialize(attributes = {})
    self.attributes = attributes
  end
  
  def attributes=(hash)
    hash.each do |key, value|
      send("#{key}=", value)
    end
  end
  
  def attribute_names
    self.class.attribute_names
  end
  
  def attributes
    attribute_names.inject({}) { |h,n| h[n] = send(n); h }
  end
  
  def model_name
    self.class.model_name
  end
  
  class << self
    def deserialize(data)
      new(JSON.parse(data))
    end
    
    def find(key)
      data = connection.hget(model_name, key)
      deserialize(data)
    end
    
    def attribute_names
      @attribute_names ||= []
    end
    
    def connection
      @@connection ||= Redis.new(:host => host, :port => port)
    end
    
    def connection=(redis)
      @@connection = redis
    end
    
    def host
      @host ||= 'localhost'
    end
    
    def port
      @port ||= 6379
    end
    
    def host=(a)
      @host = a
    end
    
    def port=(a)
      @port = a
    end
  end
end
