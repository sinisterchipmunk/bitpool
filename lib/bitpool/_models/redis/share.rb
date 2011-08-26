class Bitpool::Models::Redis::Share < Bitpool::Models::Redis
  attr_accessor :hash, :worker_key
  alias key hash
  
  attribute_names.push :hash, :worker_key
  
  TARGET = 0x00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF

  validates_presence_of :hash
  validate do |record|
    # hash must be <= TARGET
    if record.hash && record.hash > TARGET
      record.errors.add(:hash, "exceeds target")
    end
    
    # hash must be unique
    if connection.hexists(model_name, record.hash.to_s)
      record.errors.add(:hash, "is a duplicate")
    end
  end
  
  def save
    if valid?
      # connection.set(hash, serialize)
      # connection.mapped_hmset(hash, attributes.to_a)
      connection.hset(model_name, hash.to_s, attributes.to_json)
      true
    else false
    end
  end
  
  def save!
    if !save
      raise "Hash record not saved"
    end
  end
end
