class Bitpool::Models::Redis::Errors < Hash
  def full_messages
    inject([]) do |arr, (key, value)|
      arr + value.collect { |v| "#{key} #{value}" }
    end
  end
  
  def [](key)
    super(key) || self[key] = []
  end
end
