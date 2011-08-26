class Bitpool::Models::Redis::Worker < Bitpool::Models::Redis
  attr_accessor :name, :key, :account
  
  def complete_share(share)
    share.worker_key = key
    if share.save
      shares << share
    end
  end
  
  def shares
    @shares ||= DeferredArray.new(connection, File.join(key, "shares"), Bitpool::Models::Redis::Share)
  end
  
  def initialize(attributes = {})
    attributes[:key] ||= File.join(attributes[:account], attributes[:name]) if attributes[:account] && attributes[:name]
    super
  end
  
  private
  class DeferredArray
    attr_reader :key, :type
    
    def initialize(cxn, key, type)
      @cxn = cxn
      @key = key
      @type = type
    end
    
    def [](index)
      case index
      when Range
        @cxn.lrange(key, index.min, index.max).collect { |object_key| type.find(object_key) }
        # @cxn.lrange(key, index.min, index.max).collect { |data| type.deserialize data }
      else
        type.find(@cxn.lindex(key, index))
        # type.deserialize(@cxn.lindex(key, index))
      end
    end
    
    def []=(index, value)
      @cxn.lset(key, index, value.key)
    end
    
    def <<(object)
      if object.valid?
        @cxn.rpush(key, object.key)
      else
        raise "Cannot add invalid object"
      end
    end
    
    def length
      @cxn.llen(key)
    end
    
    def empty?
      length == 0
    end
  end
end
